#!/usr/bin/perl

use strict;

my $delim = "\t";
while(@ARGV)
{
  my $arg = shift @ARGV;

  if($arg eq '--help')
  {
    print STDOUT <DATA>;
    exit(0);
  }
  elsif($arg eq '-d')
  {
    $delim = shift @ARGV;
  }
} 

while(<STDIN>)
{
  chop;
  if(/\S/)
  {
    my ($name,@lines) = split($delim);
    print ">$name\n", join("\n",@lines), "\n";
  }
}

exit(0);

__DATA__

syntax: tab2fasta.pl [OPTIONS] < STAB

TAB is a tab-delimited file.

OPTIONS are:

-d DELIM: change the delimiter from tab to DELIM

