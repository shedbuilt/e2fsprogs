#!/bin/bash
declare -A SHED_PKG_LOCAL_OPTIONS=${SHED_PKG_OPTIONS_ASSOC}
SHED_PKG_LOCAL_DOCDIR="/usr/share/doc/${SHED_PKG_NAME}-${SHED_PKG_VERSION}"
# Create separate build directory
mkdir -v build &&
cd build || exit 1
# Configure
if [ -n "${SHED_PKG_LOCAL_OPTIONS[bootstrap]}" ]; then
LIBS=-L/tools/lib                    \
CFLAGS=-I/tools/include              \
PKG_CONFIG_PATH=/tools/lib/pkgconfig \
../configure --prefix=/usr           \
             --bindir=/bin           \
             --with-root-prefix=""   \
             --enable-elf-shlibs     \
             --disable-libblkid      \
             --disable-libuuid       \
             --disable-uuidd         \
             --disable-fsck || exit 1
else
../configure --prefix=/usr           \
             --bindir=/bin           \
             --with-root-prefix=""   \
             --enable-elf-shlibs     \
             --disable-libblkid      \
             --disable-libuuid       \
             --disable-uuidd         \
             --disable-fsck || exit 1
fi
# Build and Install
make -j $SHED_NUM_JOBS &&
make DESTDIR="$SHED_FAKE_ROOT" install &&
make DESTDIR="$SHED_FAKE_ROOT" install-libs &&
chmod -v u+w "${SHED_FAKE_ROOT}"/usr/lib/{libcom_err,libe2p,libext2fs,libss}.a || exit 1
# Install additional docs
if [ -n "${SHED_PKG_LOCAL_OPTIONS[docs]}" ]; then
    gunzip -v "${SHED_FAKE_ROOT}/usr/share/info/libext2fs.info.gz" &&
    makeinfo -o doc/com_err.info ../lib/et/com_err.texinfo &&
    install -v -m644 doc/com_err.info "${SHED_FAKE_ROOT}/usr/share/info"
fi
