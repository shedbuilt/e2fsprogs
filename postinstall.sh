#!/bin/bash
declare -A SHED_PKG_LOCAL_OPTIONS=${SHED_PKG_OPTIONS_ASSOC}
if [ -n "${SHED_PKG_LOCAL_OPTIONS[docs]}" ]; then
    install-info --dir-file=/usr/share/info/dir /usr/share/info/libext2fs.info &&
    install-info --dir-file=/usr/share/info/dir /usr/share/info/com_err.info
fi
