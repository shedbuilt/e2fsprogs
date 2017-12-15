#!/bin/bash
mkdir -v build
cd build
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
             --disable-fsck
make -j $SHED_NUMJOBS
make DESTDIR=${SHED_FAKEROOT} install
make DESTDIR=${SHED_FAKEROOT} install-libs
# Make these writable so they can be stripped later
chmod -v u+w ${SHED_FAKEROOT}/usr/lib/{libcom_err,libe2p,libext2fs,libss}.a
gunzip -v ${SHED_FAKEROOT}/usr/share/info/libext2fs.info.gz
makeinfo -o doc/com_err.info ../lib/et/com_err.texinfo
install -v -m644 doc/com_err.info ${SHED_FAKEROOT}/usr/share/info
