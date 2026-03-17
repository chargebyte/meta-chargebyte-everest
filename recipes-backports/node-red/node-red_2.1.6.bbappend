FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI:remove = "file://Fixup-dependencies-for-newer-npm-versions.patch"
SRC_URI += "file://Fixup-dependencies-for-newer-npm-versions.fixed.patch"

do_install:append() {
    find ${D}${nonarch_libdir}/node_modules/${BPN} \
        -type d -name 'build-tmp-napi-v*' -prune -exec rm -rf {} +
}
