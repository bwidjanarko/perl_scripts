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

sub get_today_date1 {
  my @months = qw(01 02 03 04 05 06 07 08 09 10 11 12);
  my ($second, $minute, $hour, $dayOfMonth, $month, $yearOffset, $dayOfWeek, $dayOfYear, $daylightSavings) = localtime(time);
  my $year = 1900 + $yearOffset;
  $dayOfMonth = "0" x (2 - length($dayOfMonth)) . $dayOfMonth;
  my $sqlTime = "$year" . "$months[$month]" . "$dayOfMonth";
  return $sqlTime;
}

sub get_date_time {
  my @months = qw(01 02 03 04 05 06 07 08 09 10 11 12);
  my ($second, $minute, $hour, $dayOfMonth, $month, $yearOffset, $dayOfWeek, $dayOfYear, $daylightSavings) = localtime(time);
  my $year = 1900 + $yearOffset;
  $dayOfMonth = "0" x (2 - length($dayOfMonth)) . $dayOfMonth;
  $hour = "0" x (2 - length($hour)) . $hour;
  my $date_time = "$year" . "$months[$month]" . "$dayOfMonth" . "$hour";
  return $date_time;
}

sub get_filename {
  my @months = qw(01 02 03 04 05 06 07 08 09 10 11 12);
  my ($second, $minute, $hour, $dayOfMonth, $month, $yearOffset, $dayOfWeek, $dayOfYear, $daylightSavings) = localtime(time);
  my $year = 1900 + $yearOffset;
  $dayOfMonth = "0" x (2 - length($dayOfMonth)) . $dayOfMonth;
  $hour = "0" x (2 - length($hour)) . $hour;
  my $filename = "/opt/rhino/rhinomics/cdr/mics_102_" . "$year" . "$months[$month]" . "$dayOfMonth" . "$hour" . "*.log";
  return $filename;
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

sub get_date_conversion {
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
  my $time_in_gmt7 = "$year" . "$months[$month]" . "$dayOfMonth";
  return $time_in_gmt7;
}

#my (@files) = `ls /opt/rhino/rhinomics/cdr/mics_102_2018110811*.log`;
#my $filename = get_filename();
#my $filename = "/home/m7istp.7.2.0.b1/m7istp/mics/cdr/mics.cdr.2018-12-18-10.8";
my $date_time = get_today_date();
#my $filename = "/home/cdr/pull/a1/mics.cdr.2018-12-19-14.17";
my $filename1 = "/home/cdr/pull/a1/mics.cdr." . $date_time . "*";
my $filename2 = "/home/cdr/pull/a2/mics.cdr." . $date_time . "*";
#my $filename1 = "/home/cdr/pull/a1/mics.cdr.2018-12-1*";
#my $filename2 = "/home/cdr/pull/a2/mics.cdr.2018-12-1*";

#my (@files) = `ls $filename`;
my (@files) = `ls $filename1 $filename2`;
#my (@files) = `ls /opt/rhino/rhinomics/cdr/mics_102_20181011094757.log`;
#my (@files) = `ls /opt/rhino/rhinomics/cdr/cdr_628118511118.txt`;
#my (@files) = `ls mics_102_2015011613*`; 
my $total_cdr = 0;
my $total_voice_cdr = 0;
my $total_sms_cdr = 0;
my $total_voice_answered = 0;
my $total_voice_abandoned = 0;
my $total_voice_no_answer = 0;
my $total_voice_busy = 0;
my $total_voice_rejected = 0;
my $total_network_failure = 0;
my $total_network_failure1 = 0;
my $total_exception = 0;
my $total_sms_success = 0;
my $total_sms_failure = 0;
my $total_charged_attempt = 0;
my $total_uncharged = 0;
my $total_charging_success = 0;
my $total_network_sms_failure = 0;
my $hour = "";
my $file_date_time = "";
my $file_date = "";
my %count_per_hour = ();
my %count_per_day = ();
my $output_file = "call_sms_attempt_" . $date_time . ".txt";
my $output_file1 = "/home/cdr/pull/script/SQM/sqm_hourly_report_" . $date_time . ".txt";
foreach my $file (@files) {
        open (INPUTFILE, $file) or die "Couldn't open $file";
        $file =~ s/^\s+//;
        $file =~ s/\s+$//;
        print "Processing $file ...";
        while (<INPUTFILE>) {
              $_ =~ s/^\s+//;
              $_ =~ s/\s+$//;
              $file =~ s/^\s+//;
              $file =~ s/\s+$//;
              #next if ($_ =~ /#/);
              my @data = split(/[|]/,$_);
              $file_date_time = get_date_hour_conversion($data[4]);
              #print $_;
              #print $data[2], $data[4], $file_date_time;
              if (not exists $count_per_hour{$file_date_time}) {
                     $count_per_hour{$file_date_time}[0] = 0; ## total_cdr ##
                     $count_per_hour{$file_date_time}[1] = 0; ## total_voice_cdr ##
                     $count_per_hour{$file_date_time}[2] = 0; ## total_voice_rejected ##
                     $count_per_hour{$file_date_time}[3] = 0; ## total_voice_answered ##
                     $count_per_hour{$file_date_time}[4] = 0; ## total_voice_abandoned ##
                     $count_per_hour{$file_date_time}[5] = 0; ## total_voice_no_answer ##
                     $count_per_hour{$file_date_time}[6] = 0; ## total_voice_busy ##
                     $count_per_hour{$file_date_time}[7] = 0; ## total_other (use formula) ##
                     $count_per_hour{$file_date_time}[8] = 0; ## total_network_failure ##
                     $count_per_hour{$file_date_time}[9] = 0; ## total_exception ##
                     $count_per_hour{$file_date_time}[10] = 0; ## total_uncharged ##
                     $count_per_hour{$file_date_time}[11] = 0; ## total_charging_success ##
                     $count_per_hour{$file_date_time}[12] = 0; ## total_charging_failure (use formule) ##
                     $count_per_hour{$file_date_time}[13] = 0; ## total_sms_cdr ##
                     $count_per_hour{$file_date_time}[14] = 0; ## total_sms_success ##
                     $count_per_hour{$file_date_time}[15] = 0; ## total_sms_failure ##
                     $count_per_hour{$file_date_time}[16] = 0; ## voice_sms_success_rate ##
                     $count_per_hour{$file_date_time}[17] = 0; ## voice_success_rate ##
                     $count_per_hour{$file_date_time}[18] = 0;  ## charging_sr ##
                     $count_per_hour{$file_date_time}[19] = 0; ## total charge_attempt ##
                     $count_per_hour{$file_date_time}[20] = 0; ## total_network_sms_failure ##
                     $count_per_hour{$file_date_time}[21] = 0; ## total_network_failure1 ##
              }
              $count_per_hour{$file_date_time}[0]++;
              if ($data[2] !~ /SMS/) {
                 $count_per_hour{$file_date_time}[1]++;
                 if ($data[32] =~ /null/) {
                   $count_per_hour{$file_date_time}[2]++;
                 } elsif ($data[32] =~ /SUCCESS/) {
                   $count_per_hour{$file_date_time}[3]++;
                 } elsif ($data[32] =~ /ABANDON/) {
                   $count_per_hour{$file_date_time}[4]++;
                 } elsif ($data[32] =~ /NO_ANSWER/) {
                   $count_per_hour{$file_date_time}[5]++;
                 } elsif ($data[32] =~ /BUSY/) {
                   $count_per_hour{$file_date_time}[6]++;
                 } elsif ($data[32] =~ /null/) {
                   $count_per_hour{$file_date_time}[3]++;
                 } elsif ($data[32] =~ /ABANDON/) {
                   $count_per_hour{$file_date_time}[2]++;
                 } elsif (($data[32] =~ /CALL_INFO_REPORT/)||($data[32] =~ /ROUTE_SELECT_FAILURE/)||($data[32] =~ /SMS_FAILURE/)) {
                       $count_per_hour{$file_date_time}[8]++; ## total_network_failure ##
                       $count_per_hour{$file_date_time}[20]++; ## total_network_sms_failure ##

                       if ($data[32] =~ /CALL_INFO_REPORT/) {
                          if (($data[36] =~ /CLASS1_NO_USER_RESPONDING/)||($data[36] =~ /CLASS1_CALL_REJECTED/)||($data[36] =~ /CLASS1_SUBSCRIBER_ABSENT/)||($data[36] =~ /CLASS1_NORMAL/)||($data[36] =~ /CLASS3_SERVICE_UNAVAILABLE/)) {
                             $count_per_hour{$file_date_time}[21]++; ## total_network_failure1 ##
                          }
                       }
                 } elsif (($data[32] =~ /DIALOG_ABORT/)||($data[32] =~ /DIALOG_CLOSED/)||($data[32] =~ /OPERATION_ERROR/)||($data[32] =~ /EXCEPTION/)) {
                       $count_per_hour{$file_date_time}[9]++; ## total_exception ##
                 }
              } else {
                 $count_per_hour{$file_date_time}[13]++;
                 if ($data[32] =~ /SUCCESS/) {
                    $count_per_hour{$file_date_time}[14]++;  
                 } else {
                    $count_per_hour{$file_date_time}[15]++;
                 } 
              }
              if ($data[8] !~ /CHARGED/) {
                 $count_per_hour{$file_date_time}[10]++; ## total_uncharged ##
              } else {
                 $count_per_hour{$file_date_time}[19]++; ## total charge_attempt ##
              }
              if ($data[28] !~ /2001/) {
                 $count_per_hour{$file_date_time}[11]++; ## total_charging_success ##
              }

        }   
        close(INPUTFILE);
}
open (OUTPUT_FILE,">" . $output_file);
open (OUTPUT_FILE1,">" . $output_file1);
print OUTPUT_FILE "hours|call_attempts|total_voice|rejected|answered|abandoned|no_answer|busy|other|network_failure|exception|uncharged|charging_success|charging_failure|total_sms|sms_success|sms_failure|call_sr|voice_sr|charging_sr";
print OUTPUT_FILE1 "hours|call_attempts|total_voice|rejected|answered|abandoned|no_answer|busy|other|network_failure|exception|network_failure_1|charge_success|charging_failure|total_sms|sms_success|sms_failure|call_sr|voice_sr|charging_sr";
$, = '|';
my $datetime1 = get_today_date1();
my $datetime2 = get_date_time();
foreach my $hour (sort(keys %count_per_hour)) {
        ### other = call_attempts - (rejected+answered+abandoned+no_answer+busy+network_failure-network_failure_1+exception)
        my $tv = $count_per_hour{$hour}[1];
        my $ca = $count_per_hour{$hour}[0];
        my $nf = $count_per_hour{$hour}[8];
        my $nf1 = $count_per_hour{$hour}[21];
        my $nsf = $count_per_hour{$hour}[20];
        my $ex = $count_per_hour{$hour}[9]; 
        my $re = $count_per_hour{$hour}[2];
        my $ans = $count_per_hour{$hour}[3];
        my $aba = $count_per_hour{$hour}[4];
        my $noa = $count_per_hour{$hour}[5];
        my $bus = $count_per_hour{$hour}[6];
        $count_per_hour{$hour}[7] = $ca-($re+$ans+$aba+$noa+$bus+$nf-$nf1+$ex);
        my $tsms = $count_per_hour{$hour}[13];
        my $smss = $count_per_hour{$hour}[14];
        my $smsf = $count_per_hour{$hour}[15];
        my $call_sr = ($ca-($nsf+$ex))/$ca;  
        #print $ca, $nsf, $ex;
        my $voice_sr = ($tv-($nf+$ex-$nf1))/$tv;
        my $un = $count_per_hour{$hour}[10];
        my $cs = $count_per_hour{$hour}[11];
        my $cha = $count_per_hour{$hour}[19];
        my $ot = $ca - ($re+$ans+$aba+$noa+$bus+$nf-$nf1+$ex);
        #(call_attempts - uncharged - charging_success) charging_failure
        #print $cha, $cs, $un; 
        my $cf = $cha - $cs; 
        my $charging_sr = 0;
        if ($cha gt 0) {
           $charging_sr = $cs/$cha;
        } else {
           $charging_sr = 1;
        }
        if ($hour =~ /$datetime1/) {
           #print $hour, $datetime1;
           if ($hour le $datetime2) { 
              print OUTPUT_FILE $hour,$ca,$tv,$re,$ans,$aba,$noa,$bus,$ot,$nf,$ex,$un,$cs,$cf,$tsms,$smss,$smsf,sprintf("%.5f", $call_sr),sprintf("%.5f", $voice_sr),sprintf("%.5f", $charging_sr);
              print OUTPUT_FILE1 $hour,$ca,$tv,$re,$ans,$aba,$noa,$bus,$ot,$nf,$ex,$nf1,$cs,$cf,$tsms,$smss,$smsf,sprintf("%.5f", $call_sr),sprintf("%.5f", $voice_sr),sprintf("%.5f", $charging_sr);
           }
        }
}
close(OUTPUT_FILE);
close(OUTPUT_FILE1);
#my $host = "10.251.223.97";
#my %args = (
#  user => 'scpapps',
#  password => 'M3dianet#7',
#  debug => 'false'
#);
#my $sftp = Net::SFTP->new($host, %args);
#$sftp->put("/home/cdr/pull/script/$output_file", "/home/scpapps/irawan/temporary/$output_file");
