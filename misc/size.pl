#!/usr/bin/perl
use strict;
use warnings;
use lib $ENV{HOME}.'/Perl/lib/perl5';
use Net::DNS;

my $rr = Net::DNS::RR->new(". IN ZONEMD 012345678 1 1 c68090d90a7aed716bc459f9340e3d7c1370d4d24b7e2fc3a1ddc0b9a87153b9a9713b3c9ae5cc27777f98b8e730044c");
printf "ZONEMD RR SHA348 SIMPLE for . is %d bytes\n", length($rr->canonical);
$rr->print;

print "\n";

my $rr2 = Net::DNS::RR->new("example.com IN ZONEMD 012345678 1 1                                   08cfa1115c7b948c 4163a901270395ea 226a930cd2cbcf2f a9a5e6eb85f37c8a 4e114d884e66f176 eab121cb02db7d65 2e0cc4827e7a3204 f166b47e5613fd27 ");
printf "ZONEMD RR SHA512 SIMPLE for example.com is %d bytes\n", length($rr2->canonical);
$rr2->print;
