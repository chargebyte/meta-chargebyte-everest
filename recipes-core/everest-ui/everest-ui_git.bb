SUMMARY = "EVerest Web UI"
DESCRIPTION = "A Web UI for EVerest"
LICENSE = "Apache-2.0 & MIT"
LIC_FILES_CHKSUM = "file://LICENSE-APACHE;md5=175792518e4ac015ab6696d16c4f607e \
                    file://LICENSE-MIT;md5=b20ba9d5dcc560455958a1f4e6b89725 \
"

SRC_URI = "git://github.com/chargebyte/everest-ui.git;branch=main;protocol=https"

SRCREV = "6c45905ea1daf3ce0adcc7b00a44d5b0bccc74b1"
PV = "0.5.0-git${SRCPV}"

DEPENDS = "qtbase qtwebsockets qtconnectivity yaml-cpp"

inherit cmake_qt5 systemd

S = "${WORKDIR}/git"

SYSTEMD_SERVICE:${PN} = "everest-ui.service"
SYSTEMD_AUTO_ENABLE:${PN} = "disable"
SYSTEMD_AUTO_ENABLE:${PN}:parsley = "enable"
