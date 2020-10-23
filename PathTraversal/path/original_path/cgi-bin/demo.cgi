#!/usr/bin/perl -w

use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser);
use strict;

print header(); # print the header required for an HTML document
print "<html><head><title></title></head><body>\n";

print h1("Perl CGI Radio Button Demo");
print hr();

my @choices;
$choices[0] = "foo";
$choices[1] = "bar";
$choices[2] = "baz";

my %labels; 
$labels{'foo'} = "foo -- Won't you please pick foo?";
$labels{'bar'} = "bar -- Bar is totally the best choice, man!";
$labels{'baz'} = "baz -- All the cool kids are picking baz!";

my @superlatives;
$superlatives[0] = "AWESOME!";
$superlatives[1] = "RIGHT ON!";
$superlatives[2] = "WICKED!";

print p("<form method='post' name='main'>\n");

my $choice = "";
if (param('button')) {
	$choice = param('button')
}

print radio_group(-name=>'button',
	 -values=>\@choices,
	 -default=>$choice,
	 -linebreak=>'true',
	 -labels=>\%labels);

print submit("Make a Choice!");

if ($choice) {
	print "<h1>You chose $choice!</h1>\n";
} else {
	print "<h1>Please pick something!</h1>\n";
}

print "</form>\n";
print "</body></html>";
