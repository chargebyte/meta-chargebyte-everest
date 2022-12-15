FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://avahi-daemon.conf \
"

do_install:append() {
    install -m 0644 ${WORKDIR}/avahi-daemon.conf ${D}${sysconfdir}/avahi/avahi-daemon.conf
}

PACKAGES =+ "avahi-daemon-config"

RDEPENDS:avahi-daemon += "avahi-daemon-config"

FILES:avahi-daemon-config = " ${sysconfdir}/avahi/avahi-daemon.conf"

LICENSE:avahi-daemon-config = "LGPL-2.1-or-later"
