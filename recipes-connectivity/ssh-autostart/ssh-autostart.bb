SUMMARY = "Persistent control for socket-activated SSH access"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = " \
    file://ssh-autostart \
    file://ssh-autostart.conf \
    file://factory-reset \
"

PV = "2"

S = "${WORKDIR}"

inherit allarch

RDEPENDS:${PN} = "openssh-sshd systemd"

# One hash per line. This is the password hash used by legacy chargebyte
# images. A distro can override the list without putting migration policy into
# the runtime tool.
SSH_AUTOSTART_LEGACY_DEFAULT_PASSWORD_HASHES ?= "$1$QREJ3LbE$.DwELsXmyGBxjirRzEw8S1"

do_install() {
    install -d ${D}${sbindir}
    install -m 0755 ${WORKDIR}/ssh-autostart ${D}${sbindir}/ssh-autostart

    install -d ${D}${systemd_system_unitdir}/sshd.socket.d
    install -m 0644 ${WORKDIR}/ssh-autostart.conf \
        ${D}${systemd_system_unitdir}/sshd.socket.d/ssh-autostart.conf

    # The directory itself records that the SSH policy has been initialized.
    # An absent enabled marker represents an explicit disabled state.
    install -d -m 0755 ${D}${localstatedir}/lib/ssh-autostart

    install -d ${D}${datadir}/ssh-autostart
    printf '%s\n' '${SSH_AUTOSTART_LEGACY_DEFAULT_PASSWORD_HASHES}' \
        > ${D}${datadir}/ssh-autostart/legacy-default-password-hashes

    install -d ${D}${libexecdir}/factory-reset.d
    install -m 0755 ${WORKDIR}/factory-reset ${D}${libexecdir}/factory-reset.d/20_ssh-autostart
}

FILES:${PN} += " \
    ${systemd_system_unitdir}/sshd.socket.d/ \
"
