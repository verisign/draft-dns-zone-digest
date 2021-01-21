ZONE=uri.arpa
MASTER=b.iana-servers.net
KEYS=$(shell ls Keys/*.key | sed -e 's/\.key//g')

${ZONE}.signed: ${ZONE}.unsigned
	ldns-signzone -f $@_ -z 1:1 ${ZONE}.unsigned ${KEYS}
	mv $@_ $@

${ZONE}.unsigned: ${ZONE}.axfr
	ldns-read-zone -s ${ZONE}.axfr \
	| awk '$$4 != "DNSKEY"' \
	> $@_
	mv $@_ $@

${ZONE}.axfr:
	dig @${MASTER} . AXFR > $@_
	mv $@_ $@

clean:
	rm -fv ${ZONE}.*
