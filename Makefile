SRC=draft-dns-zone-digest
DST=draft-ietf-dnsop-dns-zone-digest
VER=$(shell cat ${SRC}.xml | grep '^.rfc category' | awk '{print $$3}' | awk -F= '{print $$2}' | sed -e s'/"//g' | awk -F- '{print $$NF}')
VERP=$(shell expr ${VER} - 1)
VERQ=$(shell printf '%02d' ${VERP})

all: ${DST}-${VER}.txt
	
${DST}-${VER}.txt: ${SRC}.xml
	xml2rfc ${SRC}.xml -o $@

rfcdiff: ${DST}-${VER}.txt
	mv ${DST}-${VER}.txt Versions
	cd Versions; bash ../rfcdiff ${DST}-${VERQ}.txt ${DST}-${VER}.txt ${DST}-${VER}-from-${VERQ}.diff.html

.PHONY: clean
	
clean:
	rm -f ${DST}-${VER}.txt
