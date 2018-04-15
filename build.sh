#!/bin/bash
mkdir -v build
cd build
if [ "$SHED_BUILD_MODE" == 'bootstrap' ]; then
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
make -j $SHED_NUM_JOBS &&
make DESTDIR="$SHED_FAKE_ROOT" install &&
make DESTDIR="$SHED_FAKE_ROOT" install-libs &&
chmod -v u+w "${SHED_FAKE_ROOT}"/usr/lib/{libcom_err,libe2p,libext2fs,libss}.a &&
gunzip -v "${SHED_FAKE_ROOT}/usr/share/info/libext2fs.info.gz" &&
makeinfo -o doc/com_err.info ../lib/et/com_err.texinfo &&
install -v -m644 doc/com_err.info "${SHED_FAKE_ROOT}/usr/share/info"
