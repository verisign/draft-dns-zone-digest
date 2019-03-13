#!/bin/sh
LD_LIBRARY_PATH=/usr/local/lib
export LD_LIBRARY_PATH
set -e

echo CHECKING simple-example
$HOME/Edit/ldns-zone-digest/ldns-zone-digest -v example simple-example

echo CHECKING complex-example
$HOME/Edit/ldns-zone-digest/ldns-zone-digest -v example complex-example

echo CHECKING root-servers.net
$HOME/Edit/ldns-zone-digest/ldns-zone-digest -v root-servers.net root-servers.net

echo CHECKING uri.arpa
$HOME/Edit/ldns-zone-digest/ldns-zone-digest -v uri.arpa uri.arpa/uri.arpa.wrapped

echo "ALL GOOD"
