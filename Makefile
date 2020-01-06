SRC=draft-dns-zone-digest
DST=draft-ietf-dnsop-dns-zone-digest
VER=$(shell cat ${SRC}.xml | grep '^.rfc category' | awk '{print $$3}' | awk -F= '{print $$2}' | sed -e s'/"//g' | awk -F- '{print $$NF}')

all: ${DST}-${VER}.txt
	
${DST}-${VER}.txt: ${SRC}.xml
	xml2rfc ${SRC}.xml -o $@

.PHONY: clean
	
clean:
	rm -f ${DST}-${VER}.txt
