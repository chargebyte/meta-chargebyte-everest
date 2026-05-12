FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

do_install:append() {
	# systemd does not parse /lib/systemd/journald.conf.d, but /usr/lib/systemd/journald.conf.d
	mkdir -p ${D}/usr/lib/systemd
	mv ${D}${systemd_unitdir}/journald.conf.d ${D}/usr/lib/systemd/journald.conf.d
	# drop the other configs, which were also misplaced
	rm -rf ${D}/lib
}

FILES:${PN} += "/usr/lib/systemd/journald.conf.d/"
