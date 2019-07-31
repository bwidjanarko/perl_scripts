$, = ' ';               # set output field separator
$\ = "\n";              # set output record separator
$FS = '|';
use strict;
use warnings;
use Time::Local;

sub get_today_date {
  my @months = qw(01 02 03 04 05 06 07 08 09 10 11 12);
  my ($second, $minute, $hour, $dayOfMonth, $month, $yearOffset, $dayOfWeek, $dayOfYear, $daylightSavings) = localtime(time);
  my $year = 1900 + $yearOffset;
  $dayOfMonth = "0" x (2 - length($dayOfMonth)) . $dayOfMonth;
  my $sqlTime = "$year" . "-" . "$months[$month]" . "-" . "$dayOfMonth";
  return $sqlTime;
}

sub get_few_days_ago {
  my $days_ago = shift;
  my @months = qw(01 02 03 04 05 06 07 08 09 10 11 12);
  my ($second, $minute, $hour, $dayOfMonth, $month, $yearOffset, $dayOfWeek, $dayOfYear, $daylightSavings) = localtime(time-(scalar($days_ago)*86400));
  my $year = 1900 + $yearOffset;
  $dayOfMonth = "0" x (2 - length($dayOfMonth)) . $dayOfMonth;
  my $sqlTime = "$year" . "-" . "$months[$month]" . "-" . "$dayOfMonth";
  return $sqlTime;
}


sub get_date_hour_conversion {
  ### date time must be in 2017-01-29 16:00:01.162Z format 2018/10/07 16:52:08.000 format ###
  my $date_time = shift;
  my ($year, $month, $dayOfMonth, $hour, $min, $sec) = ($date_time =~ m/(\d{4})\/(\d{2})\/(\d{2})\s(\d{2}):(\d{2}):(\d{2})/g);
  #local @m = ($date_time =~ m/(\d{4})-(\d{2})-(\d{2})\s(\d{2}):(\d{2}):(\d{2})/g);
  my $time_in_local = timelocal($sec, $min, $hour, $dayOfMonth, scalar($month)-1, $year);
  ($sec, $min, $hour, $dayOfMonth, $month, my $yearOffset, my $dayOfWeek, my $dayOfYear, my $daylightSavings) = localtime($time_in_local+(7*3600));
  my @months = qw(01 02 03 04 05 06 07 08 09 10 11 12);
  $year = 1900 + $yearOffset;
  $dayOfMonth = "0" x (2 - length($dayOfMonth)) . $dayOfMonth;
  $hour = "0" x (2 - length($hour)) . $hour;
  $min = "0" x (2 - length($min)) . $min;
  $sec = "0" x (2 - length($sec)) . $sec;
  my $time_in_gmt7 = "$year" . "$months[$month]" . "$dayOfMonth" . "$hour";
  return $time_in_gmt7;
}

sub get_success_rate_company {
  my $query_date = shift;
  my %countPerCompany = ();
  my %companyName = ();
  my $companyId = "";
  print "Getting Company Success Rate on $query_date";
  my $inputfile = "mics_company.txt";
  open (INPUTFILE, $inputfile) or die "Couldn't open $inputfile";
  while (<INPUTFILE>) {
      $_ =~ s/^\s+//;
      $_ =~ s/\s+$//;
      my @data = split(/[,]/,$_);
      $companyId = $data[0];
      #print $data[0], $data[1];
      unless (exists $companyName{$companyId}) {
              $companyName{$companyId}{'CompanyName'} = $data[1];
      }
  }
  close (INPUTFILE);
  my $date_time = get_today_date();
  my $filename1 = "/home/cdr/pull/a1/mics.cdr." . $date_time . "*";
  my $filename2 = "/home/cdr/pull/a2/mics.cdr." . $date_time . "*";
  $date_time = get_few_days_ago(1);
  my $filename3 = "/home/cdr/pull/a1/mics.cdr." . $date_time . "*";
  my $filename4 = "/home/cdr/pull/a2/mics.cdr." . $date_time . "*";
  $date_time = get_few_days_ago(2);
  my $filename5 = "/home/cdr/pull/a1/mics.cdr." . $date_time . "*";
  my $filename6 = "/home/cdr/pull/a2/mics.cdr." . $date_time . "*";
  $date_time = get_few_days_ago(3);
  my $filename7 = "/home/cdr/pull/a1/mics.cdr." . $date_time . "*";
  my $filename8 = "/home/cdr/pull/a2/mics.cdr." . $date_time . "*";
  $date_time = get_few_days_ago(4);
  my $filename9 = "/home/cdr/pull/a1/mics.cdr." . $date_time . "*";
  my $filename10 = "/home/cdr/pull/a2/mics.cdr." . $date_time . "*";
  $date_time = get_few_days_ago(5);
  my $filename11 = "/home/cdr/pull/a1/mics.cdr." . $date_time . "*";
  my $filename12 = "/home/cdr/pull/a2/mics.cdr." . $date_time . "*";
  $date_time = get_few_days_ago(6);
  my $filename13 = "/home/cdr/pull/a1/mics.cdr." . $date_time . "*";
  my $filename14 = "/home/cdr/pull/a2/mics.cdr." . $date_time . "*";
  $date_time = get_few_days_ago(7);
  my $filename15 = "/home/cdr/pull/a1/mics.cdr." . $date_time . "*";
  my $filename16 = "/home/cdr/pull/a2/mics.cdr." . $date_time . "*";
  $date_time = get_few_days_ago(8);
  my $filename17 = "/home/cdr/pull/a1/mics.cdr." . $date_time . "*";
  my $filename18 = "/home/cdr/pull/a2/mics.cdr." . $date_time . "*";
  print $filename17, $filename18;
  #die "Shitt .. ";

  my (@files) = `ls $filename1 $filename2 $filename3 $filename4 $filename5 $filename6 $filename7 $filename8 $filename9 $filename10 $filename11 $filename12 $filename13 $filename14 $filename15 $filename16 $filename17 $filename18`;

  my $output_file = "call_sms_company_yogi_" . $query_date . ".txt";
  my $init_file = "init.txt";
  open (INITFILE,">" . $init_file);
  foreach my $file (@files) {
      $file =~ s/^\s+//;
      $file =~ s/\s+$//;
      print "Processing $file ...";
      open (INPUTFILE, $file) or die "Couldn't open $file";
      while (<INPUTFILE>) {
           $_ =~ s/^\s+//;
           $_ =~ s/\s+$//;
           #print $_;
           my @data = split(/[|]/,$_);
           #print $data[2],$data[12],$data[32],$data[36];
           my $serviceType = "";
           my $transparent_data = "";
           $serviceType = $data[2];
           my $callingParty = $data[12];
           my $setupStatus = $data[32];
           $transparent_data = $data[36]; 
           my $global_cell_id = $data[21];
           next if ($serviceType eq "SMS"); ## we don't need SMS data ## 
           my @tr_data = split(/[:]/,$transparent_data);
           my $transparent_data_msg = "";
           $companyId = "";
           foreach (@tr_data) {
              my @data1 = split(/[=]/,$_);
              if ($data1[0] eq 'coid') {
                 $companyId = $data1[1];
              }
              if ($data1[0] eq 'msg') {
                 $transparent_data_msg = $data1[1];
              }
           }
           ### if $companyId is still null then it should be REDIR call type ###
           next if ($companyId eq ""); 
           ### ONLY FOR SIP NUMBERS, REMOVE THIS AFTERWARDS !!! ###
           next if ($global_cell_id ne "510102500325003");
           ### only process company with following companyId
           # next if (($companyId ne "10688") and ($companyId ne "10694") and ($companyId ne "10695"));
           my $file_date_time = get_date_hour_conversion($data[4]);
           #print $companyId, $file_date_time;
           unless (exists $countPerCompany{$companyId}{$file_date_time}) {
                  print INITFILE "Init : ", $companyId, $file_date_time;
                  $countPerCompany{$companyId}{$file_date_time}{'TotalVoice'} = 0; 
                  $countPerCompany{$companyId}{$file_date_time}{'Outgoing'} = 0;
                  $countPerCompany{$companyId}{$file_date_time}{'Incoming'} = 0;
                  $countPerCompany{$companyId}{$file_date_time}{'Hunting'} = 0;
                  $countPerCompany{$companyId}{$file_date_time}{'Rejected'} = 0;
                  $countPerCompany{$companyId}{$file_date_time}{'Answered'} = 0;
                  $countPerCompany{$companyId}{$file_date_time}{'Abandon'} = 0;
                  $countPerCompany{$companyId}{$file_date_time}{'NoAnswer'} = 0;
                  $countPerCompany{$companyId}{$file_date_time}{'Busy'} = 0;
                  $countPerCompany{$companyId}{$file_date_time}{'NetworkFailure'} = 0;
                  $countPerCompany{$companyId}{$file_date_time}{'NetworkSMSFailure'} = 0;
                  $countPerCompany{$companyId}{$file_date_time}{'NetworkShit'} = 0;
                  $countPerCompany{$companyId}{$file_date_time}{'NetworkFailure'} = 0;
                  $countPerCompany{$companyId}{$file_date_time}{'NetworkSMSFailure'} = 0;
                  $countPerCompany{$companyId}{$file_date_time}{'Exception'} = 0;
           } 
           if ($companyId ne "") {
              $countPerCompany{$companyId}{$file_date_time}{'TotalVoice'}++;
              if ($setupStatus eq 'null') {
                 $countPerCompany{$companyId}{$file_date_time}{'Rejected'}++; 
              } elsif ($setupStatus eq 'SUCCESS') {
                 $countPerCompany{$companyId}{$file_date_time}{'Answered'}++;
              } elsif ($setupStatus eq 'ABANDON') {
                 $countPerCompany{$companyId}{$file_date_time}{'Abandon'}++;
              } elsif ($setupStatus eq 'NO_ANSWER') {
                 $countPerCompany{$companyId}{$file_date_time}{'NoAnswer'}++;
              } elsif ($setupStatus eq 'BUSY') {
                 $countPerCompany{$companyId}{$file_date_time}{'Busy'}++;
              } elsif ($setupStatus eq 'CALL_INFO_REPORT') {
                 #print $transparent_data_msg;
                 $countPerCompany{$companyId}{$file_date_time}{'NetworkFailure'}++;  
                 $countPerCompany{$companyId}{$file_date_time}{'NetworkSMSFailure'}++;
                 if ($transparent_data_msg eq 'CLASS1_NO_USER_RESPONDING') {
                    $countPerCompany{$companyId}{$file_date_time}{'NetworkShit'}++;
                 } elsif ($transparent_data_msg eq 'CLASS1_CALL_REJECTED') {
                    $countPerCompany{$companyId}{$file_date_time}{'NetworkShit'}++;  
                 } elsif ($transparent_data_msg eq 'CLASS1_SUBSCRIBER_ABSENT') {
                    $countPerCompany{$companyId}{$file_date_time}{'NetworkShit'}++;
                 } elsif ($transparent_data_msg eq 'CLASS1_NORMAL') {
                    $countPerCompany{$companyId}{$file_date_time}{'NetworkShit'}++;
                 } elsif ($transparent_data_msg eq 'CLASS3_SERVICE_UNAVAILABLE') {
                    $countPerCompany{$companyId}{$file_date_time}{'NetworkShit'}++;
                 }
              } elsif ($setupStatus eq 'ROUTE_SELECT_FAILURE') {
                 #print $transparent_data_msg;
                 $countPerCompany{$companyId}{$file_date_time}{'NetworkFailure'}++;
                 $countPerCompany{$companyId}{$file_date_time}{'NetworkSMSFailure'}++;
              } elsif ($setupStatus eq 'SMS_FAILURE') {
                 #print $transparent_data_msg;
                 $countPerCompany{$companyId}{$file_date_time}{'NetworkFailure'}++;
                 $countPerCompany{$companyId}{$file_date_time}{'NetworkSMSFailure'}++;
              } elsif ($setupStatus eq 'DIALOG_ABORT') {
                 #print $transparent_data_msg;
                 $countPerCompany{$companyId}{$file_date_time}{'Exception'}++;
              } elsif ($setupStatus eq 'DIALOG_CLOSED') {
                 #print $transparent_data_msg;
                 $countPerCompany{$companyId}{$file_date_time}{'Exception'}++;
              } elsif ($setupStatus eq 'OPERATION_ERROR') {
                 #print $transparent_data_msg;
                 $countPerCompany{$companyId}{$file_date_time}{'Exception'}++;
              } elsif ($setupStatus eq 'EXCEPTION') {
                 #print $transparent_data_msg;
                 $countPerCompany{$companyId}{$file_date_time}{'Exception'}++;
              }
              if ($serviceType eq 'MOC') {
                 $countPerCompany{$companyId}{$file_date_time}{'Outgoing'}++;
              } elsif ($serviceType eq 'MTC') {
                 $countPerCompany{$companyId}{$file_date_time}{'Incoming'}++;
              } elsif ($serviceType =~ /HUNT/) {
                 $countPerCompany{$companyId}{$file_date_time}{'Hunting'}++;
              }
           } 
      }
      close(INPUTFILE);
  }
  close(INITFILE);
  open (OUTPUT_FILE,">" . $output_file);
  $, = '|';
  print OUTPUT_FILE "id|name|hour|voice|outgoing|incoming|hunting|reject|answer|abandon|no answer|busy|other|nf|nf1|network fail|exception|sr";
  foreach my $companyId (sort(keys %countPerCompany)) {
          foreach my $file_date_time (sort(keys %{$countPerCompany{$companyId}})) {
                  #print $companyId, $file_date_time;
                  my $tv = $countPerCompany{$companyId}{$file_date_time}{'TotalVoice'};
                  my $out = $countPerCompany{$companyId}{$file_date_time}{'Outgoing'};
                  my $inc = $countPerCompany{$companyId}{$file_date_time}{'Incoming'};
                  my $hunt = $countPerCompany{$companyId}{$file_date_time}{'Hunting'};
                  my $nf = $countPerCompany{$companyId}{$file_date_time}{'NetworkFailure'};
                  my $nf1 = $countPerCompany{$companyId}{$file_date_time}{'NetworkShit'};
                  my $ex = $countPerCompany{$companyId}{$file_date_time}{'Exception'};
                  my $ca =  $countPerCompany{$companyId}{$file_date_time}{'CallAttempts'};
                  my $re = $countPerCompany{$companyId}{$file_date_time}{'Rejected'};
                  my $ans = $countPerCompany{$companyId}{$file_date_time}{'Answered'};
                  my $aba = $countPerCompany{$companyId}{$file_date_time}{'Abandon'};
                  my $noa = $countPerCompany{$companyId}{$file_date_time}{'NoAnswer'};
                  my $bus = $countPerCompany{$companyId}{$file_date_time}{'Busy'};
                  $ca = $tv;
                  my $other = $ca - ($re+$ans+$aba+$noa+$bus+$ex+$nf-$nf1);
                  my $network_failure = $nf - $nf1;
                  my $voice_sr = (($tv-($nf+$ex-$nf1))/$tv)*100;
                  unless (exists $companyName{$companyId}{'CompanyName'}) { 
                         print "Unknown Company ID : ",$companyId;
                         $companyName{$companyId}{'CompanyName'} = "UNKNOWN";
                  }
                  print OUTPUT_FILE $companyId, $companyName{$companyId}{'CompanyName'}, $file_date_time, $tv, $out, $inc, $hunt, $re, $ans, $aba, $noa, $bus, $other, $nf, $nf1, $network_failure, $ex, sprintf("%.4f", $voice_sr); 
          } 
  }
  close(OUTPUT_FILE);
}

my $queryDate = get_today_date();
get_success_rate_company($queryDate);
