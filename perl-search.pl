#!/usr/bin/perl
#Last edited on 4/1/2020 11:22AM
#(C)Tsubasa Kato 2020. C algorithm Coded by Beshoy M.
use strict;
use warnings;
use Time::HiRes qw/gettimeofday/;

my $db_file = 'database.txt';
my $counter = 0;

open(my $in,'<', $db_file) or die("unable to open $db_file");
my @lines = <$in>;
#print @lines;

print "Please input query: ";
chomp(my $input = <STDIN>);
#    $input=trim($input);
#print "Your Choice was: $input \n";
#  浮動小数点数で経過時間を取得（このサンプルだと0.20xxxx秒程）
my ($start_sec, $start_microsec) = gettimeofday();
for my $line (@lines) {
		
		$counter = $counter +1;
		#print $line;
		
	    if ("$line" =~ /$input/) {
	    	print "Perl Regex matched on line $counter\n";
	    	print "$line\n";
	}
	
}
my ($end_sec, $end_microsec) = gettimeofday();
my $interval = ($end_sec - $start_sec) * 1000000 + $end_microsec - $start_microsec;
print "Total:" . $interval . " microseconds\n";