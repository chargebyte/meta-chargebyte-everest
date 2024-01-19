# cleanup installed config files
do_install:append() {
    rm -rf ${D}${sysconfdir}/everest/config*.yaml
}
