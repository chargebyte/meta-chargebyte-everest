# include bugfix for #522
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://0001-Fix-connector-lock-unlock-too-early-before-relais-op.patch \
"
