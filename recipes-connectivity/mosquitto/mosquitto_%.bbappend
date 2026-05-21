FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += "file://10-everest-unix-domain-socket.conf"

do_install:append() {
    install -d ${D}${nonarch_base_libdir}/mosquitto/conf.d
    install -m 644 ${WORKDIR}/10-everest-unix-domain-socket.conf ${D}${nonarch_base_libdir}/mosquitto/conf.d/10-everest-unix-domain-socket.conf
}

FILES:${PN}:append = " ${nonarch_base_libdir}/mosquitto/conf.d"
