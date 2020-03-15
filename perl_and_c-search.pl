#!/usr/bin/perl
#Last edited on 3/15/2020 8:16AM
#(C)Tsubasa Kato 2020. C algorithm Coded by Beshoy M.
use strict;
use warnings;
use Time::HiRes qw/gettimeofday/;
use Inline 'C';

my $conf_file = 'database.txt';
my $counter = 0;

open(my $in,'<', $conf_file) or die("unable to open $conf_file");
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
	

    Compare($input,$line, 20);
}
my ($end_sec, $end_microsec) = gettimeofday();
my $interval = ($end_sec - $start_sec) * 1000000 + $end_microsec - $start_microsec;
print "Total:" . $interval . " microseconds\n";
__END__
__C__
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
int arr_prime[] = {2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71};

int length1;
int length2;

double time_spent = 0.0;

int Compare(char* query , char* data, int threshold)
{
	double time_spent = 0.0;
	clock_t begin_time = clock();

	int found = 0;
	int currentIndex = 5 , j = 0 , k = 0;
	int misValue = 0 , prim = arr_prime[currentIndex] , i = arr_prime[currentIndex];
	length1 = strlen(query);
	length2 = strlen(data);
	if(strcmp(query,data) == 0)
	{
		printf("two strings are completely matched\n");
		return 1;
	}
	while(1)
	{

		printf("Current index: %d\n", arr_prime[currentIndex]);
		while(i > length2)
		{
			printf("Current index2: %d\n", arr_prime[currentIndex]);
			//i -= arr_prime[currentIndex--];
			i -= arr_prime[currentIndex--];
			if(currentIndex < 0)
			{
				printf("two strings are not matched\n");
				return 0;
			}
			i += arr_prime[currentIndex];
		}
		for(j = i , k = 0; j < length2; j++)
		{
			if(query[k] == data[j])
			{
				if(k == length1 - 1)
				{

					found = 1;
					k = 0;
				}
				else
					k++;
			}
			else
			{
				k = 0;
				misValue++;
				//printf("miss value: %d\n", misValue);

			}
		}
		//Original: if(found && misValue <= threshold)
		int threshold2 = threshold * 3;
		if(found && misValue <= threshold2)
		{
			printf("two strings are partially matched within threshold.\n");
			printf("%s", data);
			//clock_t end_time = clock();
			//time_spent += (double)(end_time - begin_time) / CLOCKS_PER_SEC;

			//printf("Time elpased is %f seconds", time_spent);
			return 1;
		}
		if(found){
			printf("two strings were partially matched\n");
			printf("%s", data);
			//clock_t end_time = clock();
			
			//time_spent += (double)(end_time - begin_time) / CLOCKS_PER_SEC;

			//printf("Time elpased is %f seconds\n", time_spent);
			return 1;
		}


		found = 0;
		i += arr_prime[currentIndex];
	}
	printf("%s\n", query);
	printf("%s\n", data);
	printf("two strings are not matched\n");
	
	return 0;
}
