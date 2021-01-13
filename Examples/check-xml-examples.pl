#!/usr/bin/perl
use strict;
use warnings;
use XML::LibXML;
use File::Temp;
use Net::DNS;

my $fn = shift || die "usage: $0 xmlfile\n";

open(F, $fn) or die "$fn: $!\n";

my $xml_string;
my $entities = { 'amp' => '' };
while (<F>) {
# <!ENTITY RFC8174 PUBLIC "" "http://xml2rfc.ietf.org/public/rfc/bibxml/reference.RFC.8174.xml">
# <!ENTITY RRNAME "ZONEMD">
	if (/^<!ENTITY\s+(\S+)\s+.*"([^"]+)">$/) {
		$entities->{$1} = $2;
		next;
	}
	while (/\&(\S+);/) {
		my $k = $1;
		my $v = $entities->{$k};
		s/\&$k;/$v/;
	}
	$xml_string .= $_;
}

my $xml = XML::LibXML->load_xml(string => $xml_string);


foreach my $sect ($xml->findnodes('/rfc/back/section')) {
	next unless $sect->getAttribute('title') eq 'Example Zones With Digests';
	foreach my $subsect ($sect->findnodes('./section')) {
		print "\n";
		print '===== ', $subsect->getAttribute('title'), " =====\n";
		my $artwork = $subsect->findnodes('./figure/artwork');
		die unless $artwork;
		my ($fh, $fn) = File::Temp::tempfile(UNLINK=>1);
		$fh->print($artwork->to_literal);
		$fh->close;
		# 
		# assume actual SOA record is at the top of the zone file
		# 
		my $zn = `cat $fn | grep SOA | head -n 1 | awk '{print \$1}'`;
		die unless $zn;
		chomp($zn);
		print "$ENV{HOME}/Edit/ldns-zone-digest/ldns-zone-digest -v $zn $fn\n";
		system "$ENV{HOME}/Edit/ldns-zone-digest/ldns-zone-digest -v $zn $fn\n";
		print "\n\n";
	}
	last;
}
