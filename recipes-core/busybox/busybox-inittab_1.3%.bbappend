do_install() {
	install -d ${D}${sysconfdir}
	install -D -m 0644 ${WORKDIR}/inittab ${D}${sysconfdir}/inittab

	tmp="${SERIAL_CONSOLES}"
	[ -n "$tmp" ] && echo >> ${D}${sysconfdir}/inittab
	for i in $tmp
	do
		id=`echo ${i} | sed -e 's/^.*;//' -e 's/;.*//'`
		echo "$id::respawn:${base_bindir}/login -f root" >> ${D}${sysconfdir}/inittab
	done

	echo >> ${D}${sysconfdir}/inittab
	echo "null::sysinit:${base_sbindir}/syslogd" >> ${D}${sysconfdir}/inittab
}
