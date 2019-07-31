$, = ' ';               # set output field separator
$\ = "\n";              # set output record separator
$FS = '|';
use strict;
use warnings;
use Time::Local;

my %countPerDay = ();
my %countPerDay1 = ();
my @file_list = ("monthly_report1_2019-07-16.txt");
#my @file_list = ("sqn_report1_2019-03-11.txt");
#my @file_list1 = ("mics_old.txt");
foreach my $file (@file_list) {
        open (INPUTFILE, $file) or die "Couldn't open $file";
        print ("Processing",$file);
        while (<INPUTFILE>) {
        			$_ =~ s/^\s+//;
      				$_ =~ s/\s+$//;      				
      				my @data = split(/[|]/,$_);
      				next if ($data[1] =~ /hours/);
        			my $date_hour = $data[0];
        			my $date = substr $data[0], 0, 8;
        			my $hour = substr $data[0], 8, 2;
        			unless (exists $countPerDay{$date}) {
                     $countPerDay{$date}{'TotalAttempt'} = 0;
                     $countPerDay{$date}{'TotalVoice'} = 0;
                     $countPerDay{$date}{'Rejected'} = 0;
                     $countPerDay{$date}{'Answered'} = 0;
                     $countPerDay{$date}{'Abandon'} = 0;
                     $countPerDay{$date}{'NoAnswer'} = 0;
                     $countPerDay{$date}{'Busy'} = 0;
                     $countPerDay{$date}{'NetworkSMSFailure'} = 0;
                     $countPerDay{$date}{'NetworkFailure'} = 0;
                     $countPerDay{$date}{'NetworkFailure1'} = 0;
                     $countPerDay{$date}{'Exception'} = 0;
                     $countPerDay{$date}{'Uncharged'} = 0;
                     $countPerDay{$date}{'ChargedSuccess'} = 0;
                     $countPerDay{$date}{'TotalSMS'} = 0;
                     $countPerDay{$date}{'SMSSuccess'} = 0;
                     $countPerDay{$date}{'SMSFailure'} = 0;
                     $countPerDay{$date}{'CallSR'} = 0;
                     $countPerDay{$date}{'Peak'} = 0;
                     $countPerDay{$date}{'PeakHour'} = "";
            	}
            	print "TotalAttempt SMS : $date : $data[14]";
            	$countPerDay{$date}{'TotalAttempt'} += scalar($data[1]);
              $countPerDay{$date}{'TotalVoice'} += scalar($data[2]);
              $countPerDay{$date}{'Rejected'} += scalar($data[3]);
              $countPerDay{$date}{'Answered'} += scalar($data[4]);
              $countPerDay{$date}{'Abandon'} += scalar($data[5]);
              $countPerDay{$date}{'NoAnswer'} += scalar($data[6]);
              $countPerDay{$date}{'Busy'} += scalar($data[7]);
              $countPerDay{$date}{'NetworkSMSFailure'} += scalar($data[8]);
              $countPerDay{$date}{'NetworkFailure'} += scalar($data[9]);
              $countPerDay{$date}{'NetworkFailure1'} += scalar($data[10]);
              $countPerDay{$date}{'Exception'} += scalar($data[11]);
              $countPerDay{$date}{'Uncharged'} += scalar($data[12]);
              $countPerDay{$date}{'ChargedSuccess'} += scalar($data[13]);
              $countPerDay{$date}{'TotalSMS'} += scalar($data[14]);
              $countPerDay{$date}{'SMSSuccess'} += scalar($data[15]);
              $countPerDay{$date}{'SMSFailure'} += scalar($data[16]);
              my $peakHour = $countPerDay{$date}{'Peak'};
              if (scalar($data[1]) > $peakHour) {
              	 $countPerDay{$date}{'Peak'} = scalar($data[1]);
              	 $countPerDay{$date}{'PeakHour'} = $hour;
              }
              my $ca = $countPerDay{$date}{'TotalAttempt'};
              my $nsf = $countPerDay{$date}{'NetworkSMSFailure'};
              my $ex = $countPerDay{$date}{'Exception'};
              my $tv = $countPerDay{$date}{'TotalVoice'};
              my $nf = $countPerDay{$date}{'NetworkFailure'};
              my $nf1 = $countPerDay{$date}{'NetworkFailure1'};
            	my $call_sr = 0;
        			if ($ca > 0) {
           			 $call_sr = ($ca-($nsf+$ex))/$ca; 
        			} else {
           			 $call_sr = 1;
        			}
        			my $voice_sr = 0; 
        			if ($tv > 0) {
           			 $voice_sr = ($tv-($nf+$ex-$nf1))/$tv;
        			} else {
           			 $voice_sr = 1;
        			}
        			$countPerDay{$date}{'CallSR'} = $voice_sr;
      	}
      	close(INPUTFILE);
}

my $output_file = "daily_sr.txt";
open (OUTPUT_FILE,">" . $output_file);
print OUTPUT_FILE "date|call attempt|total voice|rejected|answered|abandon|no answer|busy|other|network failure|exception|uncharged|charge_success|total sms|sms success|sms failure|call sr|sms sr";
foreach my $date (sort(keys %countPerDay)) {
            my $ca = $countPerDay{$date}{'TotalAttempt'};
            my $tv = $countPerDay{$date}{'TotalVoice'};
            my $re = $countPerDay{$date}{'Rejected'};
            my $ans = $countPerDay{$date}{'Answered'};
            my $aba = $countPerDay{$date}{'Abandon'};
            my $noa = $countPerDay{$date}{'NoAnswer'};
            my $bus = $countPerDay{$date}{'Busy'};
            my $nsf = $countPerDay{$date}{'NetworkSMSFailure'};
            my $nf = $countPerDay{$date}{'NetworkFailure'};
            my $nf1 = $countPerDay{$date}{'NetworkFailure1'};
            my $ex = $countPerDay{$date}{'Exception'};
            my $un = $countPerDay{$date}{'Uncharged'};
            my $cs = $countPerDay{$date}{'ChargedSuccess'};
            my $ts = $countPerDay{$date}{'TotalSMS'};
            my $smss = $countPerDay{$date}{'SMSSuccess'};
            my $smsf = $countPerDay{$date}{'SMSFailure'};
            my $ot = $ca - ($re+$ans+$aba+$noa+$bus+$nf-$nf1+$ex);
            my $call_sr = $countPerDay{$date}{'CallSR'} * 100;
						#print $date, $countPerDay{$date}{'TotalAttempt'}, $countPerDay{$date}{'CallSR'};
						my $sms_sr = 0;
						if ($countPerDay{$date}{'TotalSMS'} > 0) {
	      				$sms_sr = ($countPerDay{$date}{'SMSSuccess'} / $countPerDay{$date}{'TotalSMS'}) * 100;
	      		} else {
	      				$sms_sr = 0;
	      		}
						print OUTPUT_FILE $date,$ca,$tv,$re,$ans,$aba,$noa,$bus,$ot,$nf,$ex,$un,$cs,$ts,$smss,$smsf,sprintf("%.5f", $call_sr), sprintf("%.5f",$sms_sr);
}
close(OUTPUT_FILE);

foreach my $date (sort(keys %countPerDay)) {
	      print $date, $countPerDay{$date}{'PeakHour'}, $countPerDay{$date}{'Peak'};
}

foreach my $date (sort(keys %countPerDay)) {
	      print $date, $countPerDay{$date}{'TotalAttempt'}, sprintf("%.5f", $countPerDay{$date}{'CallSR'} * 100);
}

foreach my $date (sort(keys %countPerDay)) {
	      if ($countPerDay{$date}{'TotalSMS'} > 0) {
	      		my $sms_sr = ($countPerDay{$date}{'SMSSuccess'} / $countPerDay{$date}{'TotalSMS'}) * 100;
	      		print $date, $countPerDay{$date}{'TotalSMS'}, sprintf("%.5f", $sms_sr);
	      }
}