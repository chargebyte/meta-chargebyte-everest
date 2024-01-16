do_install:append() {
    # cleanup installed config files
    rm -rf ${D}${sysconfdir}/everest/config*.yaml

    # create persistent state directory
    install -d -m 0755 ${D}${localstatedir}/lib/everest
}
