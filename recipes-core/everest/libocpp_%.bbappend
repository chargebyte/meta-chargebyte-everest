FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append:parsley = " \
    file://0001-Add-mcs-feature.patch \
"
