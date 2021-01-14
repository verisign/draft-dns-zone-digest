#!/usr/bin/perl
use strict;
use warnings;
use XML::LibXML;
use File::Temp;
use Net::DNS;

my $fn = shift || die "usage: $0 xmlfile\n";

open(F, $fn) or die "$fn: $!\n";

my $xml_string;
my $entities = { 'amp' => '', 'nbsp' => ' ', lt => '' };
while (<F>) {
# <!ENTITY RFC8174 PUBLIC "" "http://xml2rfc.ietf.org/public/rfc/bibxml/reference.RFC.8174.xml">
# <!ENTITY RRNAME "ZONEMD">
	if (/^<!ENTITY\s+(\S+)\s+.*"([^"]+)">$/) {
		$entities->{$1} = $2;
		next;
	}
	while (/\&([^;]+);/) {
		my $k = $1;
		my $v = $entities->{$k};
		die "'$k' in '$_'" unless defined($v);
		s/\&$k;/$v/;
	}
	$xml_string .= $_;
}

my $xml = XML::LibXML->load_xml(string => $xml_string);

sub get_title {
	my $xml = shift;
	if (my $t = $xml->getAttribute('title')) {
		return $t;
	}
	if (my $t = $xml->findvalue('name')) {
		return $t;
	}
	die "couldn't find title as either attribute or name\n";
}

sub get_artwork {
	my $xml = shift;
	if (my $a = $xml->findnodes('./figure/artwork')) {
		#print STDERR "found figure/artwork\n";
		return $a->to_literal;
	}
	if (my $a = $xml->findvalue('sourcecode')) {
		#print STDERR "found sourcecode\n";
		return $a;
	}
	die "couldn't find figure/artwork or sourcecode\n";
}

foreach my $sect ($xml->findnodes('/rfc/back/section')) {
	my $title = get_title($sect);
	#print STDERR "found section with title '$title'\n";
	next unless $title eq 'Example Zones with Digests' or $title eq 'Example Zones With Digests';
	foreach my $subsect ($sect->findnodes('./section')) {
		print "\n";
		print '===== ', get_title($subsect), " =====\n";
		my $artwork = get_artwork($subsect);
		my ($fh, $fn) = File::Temp::tempfile(UNLINK=>1);
		$fh->print($artwork);
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
