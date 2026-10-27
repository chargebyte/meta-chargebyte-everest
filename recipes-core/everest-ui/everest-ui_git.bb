SUMMARY = "EVerest Web UI"
DESCRIPTION = "A Web UI for EVerest"
LICENSE = "Apache-2.0 & MIT"
LIC_FILES_CHKSUM = "file://LICENSE-APACHE;md5=175792518e4ac015ab6696d16c4f607e \
                    file://LICENSE-MIT;md5=b20ba9d5dcc560455958a1f4e6b89725 \
"

SRC_URI = " \
    git://github.com/chargebyte/everest-ui.git;branch=main;protocol=https \
    file://factory-reset \
"

SRCREV = "316fd044e3d58d17d31d2339da1aa800d104dfe4"
PV = "0.8.0-git${SRCPV}"

DEPENDS = "qtbase qtwebsockets qtconnectivity yaml-cpp"

inherit cmake_qt5 systemd

S = "${WORKDIR}/git"

SYSTEMD_SERVICE:${PN} = "everest-ui.service"
SYSTEMD_AUTO_ENABLE:${PN} = "disable"
SYSTEMD_AUTO_ENABLE:${PN}:parsley = "enable"

do_install:append() {
    install -d ${D}${libexecdir}/factory-reset.d
    install -m 0755 ${WORKDIR}/factory-reset ${D}${libexecdir}/factory-reset.d/50_everest-ui
}
