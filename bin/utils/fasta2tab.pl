#!/usr/bin/perl

use strict;

# Flush output to STDOUT immediately.
$| = 1;

my $arg;

my $fin   = \*STDIN;
my $delim = "\t";
while(@ARGV)
{
  $arg = shift @ARGV;

  if($arg eq '--help')
  {
    print STDOUT <DATA>;
    exit(0);
  }
  elsif($arg eq '-d')
  {
    $delim = shift @ARGV;
  }
  elsif(-f $arg)
  {
    open($fin,$arg) or die("Can't open file '$arg' for reading.");
  }
  
  else
  {
    die("Bad argument '$arg' given.");
  }
}

my $name="";
my $text="";
while(<$fin>)
{
  chomp;
  if(/\S/)
  {
    if(/^\s*>/)
    {
      s/^\s*>\s*//;
      if(length($name)>0)
      {
        print $name . $delim . $text . "\n";
      }
      $name = $_;
      $text = "";
    }
    else
    {
      $text .= length($text)==0 ? $_ : ($delim . $_);
    }
  }
}

if(length($text)>0)
{
  print $name . $delim . $text . "\n";
}

exit(0);

__DATA__

syntax: fasta2tab.pl [OPTIONS] < FASTA

OPTIONS are:

-d DELIM: change the delimiter from tab to DELIM



