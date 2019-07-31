$, = ' ';               # set output field separator
$\ = "\n";              # set output record separator
$FS = '|';
use strict;
use warnings;
use Time::Local;

my %cpu_report = ();
my @file_list = ("vccpdb1_cpu_201906a.csv");
foreach my $file (@file_list) {
        open (INPUTFILE, $file) or die "Couldn't open $file";
        print ("Processing",$file);
        while (<INPUTFILE>) {
      			$_ =~ s/^\s+//;
      			$_ =~ s/\s+$//;
      			next if ($_ =~ /Time/);
      			my @data = split(/[,]/,$_); 
      			$data[1] =~ s/^\s+//;
      			$data[1] =~ s/\s+$//;     			
      			my $hour_gmt = $data[0];
      			my $hour = "";
      			if ($hour_gmt =~ /2019/) {
      			   $hour = $hour_gmt =~ s/\:00 GMT\+0700 2019//r;
      			} elsif ($hour_gmt =~ /2018/) {
      				 $hour = $hour_gmt =~ s/\:00 GMT\+0700 2018//r;
      			}
      			my $sub_hour = substr $hour, 4, length($hour)-4;
      			my $date = substr $sub_hour, 0, 6;
      			unless (exists $cpu_report{$date}) {
      					$cpu_report{$date} = scalar($data[1]);
      			} else {
      				  if ($cpu_report{$date} < scalar($data[1])) {
      				  	 $cpu_report{$date} = scalar($data[1]);
      				  }
      			}
      	}
      	close(INPUTFILE);
}      	
$\ = "|";
my $output_file = "cpu_report.txt";
open (OUTPUT_FILE,">" . $output_file);
foreach my $date (sort(keys %cpu_report)) {
						print OUTPUT_FILE $date;
				}
print OUTPUT_FILE "\n";
foreach my $date (sort(keys %cpu_report)) {
						print OUTPUT_FILE $cpu_report{$date};
				}
close(OUTPUT_FILE);