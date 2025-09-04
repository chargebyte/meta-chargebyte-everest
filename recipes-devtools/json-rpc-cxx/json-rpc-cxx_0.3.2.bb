SUMMARY = "JSON-RPC 2.0 framework for modern C++ (json-rpc-cxx)"
HOMEPAGE = "https://github.com/jsonrpcx/json-rpc-cxx"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=23722aabb609187e801a18422ee3abb7"

# Fetch source code from upstream GitHub repository (tag v0.3.2)
SRC_URI = "git://github.com/jsonrpcx/json-rpc-cxx.git;protocol=https;branch=master \
           file://json-rpc-cxxConfig.cmake"
SRCREV = "a0e195b575d62cb07016321ac9cd7e1b9e048fe5"

S = "${WORKDIR}/git"

EXTRA_OECMAKE = "-DCOMPILE_TESTS=OFF -DCOMPILE_EXAMPLES=OFF -DCODE_COVERAGE=OFF"

# Dependency on nlohmann-json (already available in meta-oe)
DEPENDS = "nlohmann-json"

# After inheriting cmake and pkgconfig
do_install() {
    # Install headers
    install -d ${D}${includedir}/jsonrpccxx
    cp -r ${S}/include/jsonrpccxx/* ${D}${includedir}/jsonrpccxx/

    # Install minimal CMake config
    install -d ${D}${libdir}/cmake/json-rpc-cxx
    install -m 0644 ${WORKDIR}/json-rpc-cxxConfig.cmake \
        ${D}${libdir}/cmake/json-rpc-cxx/
}

FILES:${PN}-dev += "${libdir}/cmake/json-rpc-cxx"
