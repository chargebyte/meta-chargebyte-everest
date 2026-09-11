FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI += " \
    file://0001-Restrict-git-describe-tag-search-to-standard-pattern.patch \
    file://cmake-aggregated-generated-package-configs-order.patch \
"
