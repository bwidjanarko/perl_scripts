$, = ' ';               # set output field separator
$\ = "\n";              # set output record separator
$FS = '|';
use strict;
use warnings;
use Time::Local;

sub get_yester_month {
  my @months = qw(01 02 03 04 05 06 07 08 09 10 11 12);
  my ($second, $minute, $hour, $dayOfMonth, $month, $yearOffset, $dayOfWeek, $dayOfYear, $daylightSavings) = localtime(time-(7*86400));
  my $year = 1900 + $yearOffset;
  $dayOfMonth = "0" x (2 - length($dayOfMonth)) . $dayOfMonth;
  my $sqlTime = "$year" . "-" . "$months[$month]" . "*";
  return $sqlTime;
}

sub get_today_date {
  my @months = qw(01 02 03 04 05 06 07 08 09 10 11 12);
  my ($second, $minute, $hour, $dayOfMonth, $month, $yearOffset, $dayOfWeek, $dayOfYear, $daylightSavings) = localtime(time);
  my $year = 1900 + $yearOffset;
  $dayOfMonth = "0" x (2 - length($dayOfMonth)) . $dayOfMonth;
  my $sqlTime = "$year" . "-" . "$months[$month]" . "-" . "$dayOfMonth";
  return $sqlTime;
}


sub get_success_rate_company {
  my $query_date = shift;
  my %countPerCompany = ();
  my $companyId = "";
  print "Getting Company Success Rate on $query_date";
  my $inputfile = "mics_company.txt";
  open (INPUTFILE, $inputfile) or die "Couldn't open $inputfile";
  while (<INPUTFILE>) {
      $_ =~ s/^\s+//;
      $_ =~ s/\s+$//;
      my @data = split(/[,]/,$_);
      $companyId = $data[0];
      print $data[0], $data[1];
      unless (exists $countPerCompany{$companyId}) {
              $countPerCompany{$companyId}{'CompanyName'} = @data[1];
              $countPerCompany{$companyId}{'TotalVoice'} = 0;
              $countPerCompany{$companyId}{'Rejected'} = 0;
              $countPerCompany{$companyId}{'Answered'} = 0;
              $countPerCompany{$companyId}{'Abandon'} = 0;
              $countPerCompany{$companyId}{'NoAnswer'} = 0;
              $countPerCompany{$companyId}{'Busy'} = 0;
              $countPerCompany{$companyId}{'NetworkSMSFailure'} = 0;
              $countPerCompany{$companyId}{'NetworkFailure'} = 0;
              $countPerCompany{$companyId}{'NetworkShit'} = 0;
              $countPerCompany{$companyId}{'Exception'} = 0;
      }
  }
  my $date_time = get_yester_month();
  my $filename1 = "/home/cdr/pull/a1/mics.cdr." . $date_time;
  my $filename2 = "/home/cdr/pull/a2/mics.cdr." . $date_time;

  my (@files) = `ls $filename1 $filename2`;
  my $output_file = "call_sms_company_" . $query_date . ".txt";
  foreach my $file (@files) {
      $file =~ s/^\s+//;
      $file =~ s/\s+$//;
      print "Processing $file ...";
      open (INPUTFILE, $file) or die "Couldn't open $file";
      while (<INPUTFILE>) {
           $_ =~ s/^\s+//;
           $_ =~ s/\s+$//;
           my @data = split(/[|]/,$_);
           #print $data[2],$data[12],$data[32],$data[36];
           my $serviceType = $data[2];
           my $callingParty = $data[12];
           my $setupStatus = $data[32];
           my $transparent_data = $data[36]; 
           next if ($serviceType =~ /SMS/); ## we don't need SMS data ## 
           my @tr_data = split(/[:]/,$transparent_data);
           my $transparent_data_msg = "";
           $companyId = "";
           foreach (@tr_data) {
              my @data1 = split(/[=]/,$_);
              if (@data1[0] eq 'coid') {
                 $companyId = @data1[1];
              }
              if (@data1[0] eq 'msg') {
                 $transparent_data_msg = @data1[1];
              }
           }
           ### if $companyId is still null then it should be REDIR call type ###
           next if ($companyId eq ""); 
           if ($companyId ne "") {
              $countPerCompany{$companyId}{'TotalVoice'}++;
              if ($setupStatus eq 'null') {
                 $countPerCompany{$companyId}{'Rejected'}++;
              } elsif ($setupStatus eq 'SUCCESS') {
                 $countPerCompany{$companyId}{'Answered'}++; 
              } elsif ($setupStatus eq 'ABANDON') {
                 $countPerCompany{$companyId}{'Abandon'}++; 
              } elsif ($setupStatus eq 'NO_ANSWER') {
                 $countPerCompany{$companyId}{'NoAnswer'}++; 
              } elsif ($setupStatus eq 'BUSY') {
                 $countPerCompany{$companyId}{'Busy'}++; 
              } elsif ($setupStatus eq 'CALL_INFO_REPORT') {
                 $countPerCompany{$companyId}{'NetworkFailure'}++;
                 $countPerCompany{$companyId}{'NetworkSMSFailure'}++;
                 if ($transparent_data_msg eq 'CLASS1_NO_USER_RESPONDING') {
                    $countPerCompany{$companyId}{'NetworkShit'}++;
                 } elsif ($transparent_data_msg eq 'CLASS1_CALL_REJECTED') {
                    $countPerCompany{$companyId}{'NetworkShit'}++;
                 } elsif ($transparent_data_msg eq 'CLASS1_SUBSCRIBER_ABSENT') {
                    $countPerCompany{$companyId}{'NetworkShit'}++;
                 } elsif ($transparent_data_msg eq 'CLASS1_NORMAL') {
                    $countPerCompany{$companyId}{'NetworkShit'}++;
                 } elsif ($transparent_data_msg eq 'CLASS3_SERVICE_UNAVAILABLE') {
                    $countPerCompany{$companyId}{'NetworkShit'}++;
                 }
              } elsif ($setupStatus eq 'ROUTE_SELECT_FAILURE') {
                 $countPerCompany{$companyId}{'NetworkFailure'}++;
                 $countPerCompany{$companyId}{'NetworkSMSFailure'}++;
              } elsif ($setupStatus eq 'SMS_FAILURE') {
                 $countPerCompany{$companyId}{'NetworkFailure'}++;
                 $countPerCompany{$companyId}{'NetworkSMSFailure'}++;
              } elsif ($setupStatus eq 'DIALOG_ABORT') {
                 $countPerCompany{$companyId}{'Exception'}++;
              } elsif ($setupStatus eq 'DIALOG_CLOSED') {
                 $countPerCompany{$companyId}{'Exception'}++;
              } elsif ($setupStatus eq 'OPERATION_ERROR') {
                 $countPerCompany{$companyId}{'Exception'}++;
              } elsif ($setupStatus eq 'EXCEPTION') {
                 $countPerCompany{$companyId}{'Exception'}++;
              }
           } 
      }
      close(INPUTFILE);
  }
  open (OUTPUT_FILE,">" . $output_file);
  $, = '|';
  print OUTPUT_FILE "id|name|voice|reject|answer|abandon|no answer|busy|other|nf|nf1|network fail|exception|sr";
  foreach my $companyId (sort(keys %countPerCompany)) {
          unless (0==$countPerCompany{$companyId}{'TotalVoice'}) {
              my $tv = $countPerCompany{$companyId}{'TotalVoice'};
              my $nf = $countPerCompany{$companyId}{'NetworkFailure'};
              my $nf1 = $countPerCompany{$companyId}{'NetworkShit'};
              my $ex = $countPerCompany{$companyId}{'Exception'};
              my $ca =  $countPerCompany{$companyId}{'CallAttempts'}; 
              my $re = $countPerCompany{$companyId}{'Rejected'};
              my $ans = $countPerCompany{$companyId}{'Answered'};
              my $aba = $countPerCompany{$companyId}{'Abandon'};
              my $noa = $countPerCompany{$companyId}{'NoAnswer'};
              my $bus = $countPerCompany{$companyId}{'Busy'};
              my $ca = $tv;
              my $other = $ca - ($re+$ans+$aba+$noa+$bus+$ex+$nf-$nf1);
              my $network_failure = $nf - $nf1; 
              my $voice_sr = (($tv-($nf+$ex-$nf1))/$tv)*100;
              #my $voice_sr = 0; 
              print OUTPUT_FILE $companyId, $countPerCompany{$companyId}{'CompanyName'}, $tv, $re, $ans, $aba, $noa, $bus, $other, $nf, $nf1, $network_failure, $ex, sprintf("%.4f", $voice_sr);
          }
  } 
  close(OUTPUT_FILE);
}

my $queryDate = get_today_date();
get_success_rate_company($queryDate);
