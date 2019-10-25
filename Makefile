SRC=draft-dns-zone-digest
DST=draft-ietf-dnsop-dns-zone-digest
VER=02

all: ${DST}-${VER}.txt
	
${DST}-${VER}.txt: ${SRC}.xml
	xml2rfc ${SRC}.xml -o $@

.PHONY: clean
	
clean:
	rm -f ${DST}-${VER}.txt
