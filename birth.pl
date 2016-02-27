#!/usr/bin/perl

use strict;
use warnings;

my $argc = scalar @ARGV;

## Format
# Keys known :
#  - #day \in [1,31]
#  - #month \in [1,12], #monthname
#  - #year
my $format = "REM #day #monthname MSG #name anniversary [since(#year)] year old";
if($argc >= 3) {
    $format = $ARGV[2];
}


my $key = "birthday";
if($argc >= 2) {
    $key = $ARGV[1];
}

### Constants
my @monthnames = ("Jan", "Feb", "Mar",
                  "Apr", "May", "Jun",
                  "Jul", "Aug", "Sep", 
                  "Oct", "Nov", "Dec");

if($argc >= 1 and $ARGV[0] ne "-") {
    open FILE, ">", $ARGV[0] or die "Can't open $ARGV[0] : $!\n";
    select FILE;
} else {
    select STDOUT;
}

my @contacts = split '\n', `acm get birthday ".*" "<{name}> <{$key}>"`;
for(my $i = 0; $i < scalar(@contacts); ++$i) {
    my $contact = $contacts[$i];
    if($contact =~ m/<(.*?)> <(....)-(..)-(..)>/) {
        my ($name,$year,$month,$day) = ($1,$2,$3,$4);
        my $str = $format;
        $str =~ s/#day/$day/;
        $str =~ s/#monthname/$monthnames[$month-1]/;
        $str =~ s/#month/$month/;
        $str =~ s/#year/$year/;
        $str =~ s/#name/$name/;
        print "$str\n";
    }
}

