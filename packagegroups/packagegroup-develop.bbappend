# some EVerest BSPs need it so make it available in the developer rootfs
RDEPENDS:${PN} += "sigslot-dev"

# on the Charge SOM platform, we have sufficient free space and enough
# CPU power to use these tools
RDEPENDS:${PN} += "${@bb.utils.contains("MACHINE", "chargesom", "node-red nodejs-npm", "", d)}"
