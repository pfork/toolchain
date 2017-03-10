#!/bin/bash

# Cross-Compiler Toolchain for ${PLATFORM}
#  by Martin Decky <martin@decky.cz>, stf
#
#  GPL'ed, copyleft
#


check_error() {
    if [ "$1" -ne "0" ]; then
        echo
        echo "Script failed: $2"
        exit
    fi
}

if [ -z "${CROSS_PREFIX}" ] ; then
    CROSS_PREFIX="$PWD"
fi

BINUTILS_VERSION="2.27"
GCC_VERSION="6.2.0"
GDB_VERSION="7.12"
NEWLIB_VERSION="2.4.0"

BINUTILS="binutils-${BINUTILS_VERSION}.tar.gz"
GCC_CORE="gcc-${GCC_VERSION}.tar.bz2"
GDB="gdb-${GDB_VERSION}.tar.xz"
NEWLIB="newlib-${NEWLIB_VERSION}.tar.gz"

BINUTILS_SOURCE="ftp://ftp.gnu.org/gnu/binutils/"
GCC_SOURCE="ftp://ftp.gnu.org/gnu/gcc/gcc-${GCC_VERSION}/"
GDB_SOURCE="ftp://ftp.gnu.org/gnu/gdb/"
NEWLIB_SOURCE="ftp://sourceware.org/pub/newlib/"

PLATFORM="arm"
WORKDIR="$PWD"
TARGET="${PLATFORM}-none-eabi"
PREFIX="${CROSS_PREFIX}/${PLATFORM}"
BINUTILSDIR="${WORKDIR}/binutils-${BINUTILS_VERSION}"
GDBDIR="${WORKDIR}/gdb-${GDB_VERSION}"
GCCDIR="${WORKDIR}/gcc-${GCC_VERSION}"
OBJDIR="${WORKDIR}/gcc-obj"
NEWLIBDIR="${WORKDIR}/newlib-${NEWLIB_VERSION}"

echo ">>> Downloading tarballs"

if [ ! -f "${BINUTILS}" ]; then
    wget -c "${BINUTILS_SOURCE}${BINUTILS}"
    check_error $? "Error downloading binutils."
fi
if [ ! -f "${GCC_CORE}" ]; then
    wget -c "${GCC_SOURCE}${GCC_CORE}"
    check_error $? "Error downloading GCC Core."
fi
if [ ! -f "${GDB}" ]; then
    wget -c "${GDB_SOURCE}${GDB}"
    check_error $? "Error downloading GDB."
fi
if [ ! -f "${NEWLIB}" ]; then
    wget -c "${NEWLIB_SOURCE}${NEWLIB}"
    check_error $? "Error downloading newlib."
fi

echo ">>> Creating destionation directory"
if [ ! -d "${PREFIX}" ]; then
    mkdir -p "${PREFIX}"
    test -d "${PREFIX}"
    check_error $? "Unable to create ${PREFIX}."
fi

echo ">>> Creating GCC work directory"
if [ ! -d "${OBJDIR}" ]; then
    mkdir -p "${OBJDIR}"
    test -d "${OBJDIR}"
    check_error $? "Unable to create ${OBJDIR}."
fi

echo ">>> Unpacking tarballs"
tar -xvzf "${BINUTILS}"
check_error $? "Error unpacking binutils."
tar -xvjf "${GCC_CORE}"
check_error $? "Error unpacking GCC Core."
tar -xvJf "${GDB}"
check_error $? "Error unpacking GDB."
tar -xvzf "${NEWLIB}"
check_error $? "Error unpacking NEWLIB"

echo ">>> Compiling and installing binutils"
cd "${BINUTILSDIR}"
check_error $? "Change directory failed."
./configure "--target=${TARGET}" "--prefix=${PREFIX}" "--program-prefix=${TARGET}-" "--disable-nls"
check_error $? "Error configuring binutils."
make all install
check_error $? "Error compiling/installing binutils."

echo ">>> Compiling and installing GCC"
cd "${OBJDIR}"
check_error $? "Change directory failed."
#"${GCCDIR}/configure" "--target=${TARGET}" "--prefix=${PREFIX}" "--program-prefix=${TARGET}-" --with-gnu-as --with-gnu-ld --disable-nls --disable-threads --enable-languages=c,c++ --disable-multilib --disable-libgcj --enable-libssp -disable-decimal-float --disable-libffi --disable-libgomp --disable-libmudflap --disable-libquadmath -disable-libstdcxx-pch --disable-tls --with-newlib --with-python-dir=share/gcc-arm-none-eabi --with-host-libstdcxx='-static-libgcc -Wl,-Bstatic,-lstdc++,-Bdynamic -lm' --without-headers --with-gxx-include-dir=/usr/include/c++/5.3.0
"${GCCDIR}/configure" "--target=${TARGET}" "--prefix=${PREFIX}" "--program-prefix=${TARGET}-" --with-cpu=cortex-m3 --with-mode=thumb --with-gnu-as --with-gnu-ld --disable-nls --disable-threads --enable-languages=c,c++ --disable-multilib --disable-libgcj --enable-libssp -disable-decimal-float --disable-libffi --disable-libgomp --disable-libmudflap --disable-libquadmath -disable-libstdcxx-pch --disable-tls --with-python-dir=share/gcc-arm-none-eabi --with-host-libstdcxx='-static-libgcc -Wl,-Bstatic,-lstdc++,-Bdynamic -lm' --without-headers --with-gxx-include-dir=/usr/include/c++/5.3.0
check_error $? "Error configuring GCC."
PATH="${PATH}:${PREFIX}/bin" make all-gcc install-gcc all-target-libgcc install-target-libgcc
check_error $? "Error compiling/installing GCC."

echo ">>> Compiling and installing gdb"
cd "${GDBDIR}"
check_error $? "Change directory failed."
./configure "--target=${TARGET}" "--prefix=${PREFIX}" "--program-prefix=${TARGET}-" "--disable-nls"
check_error $? "Error configuring gdb."
make all install
check_error $? "Error compiling/installing gdb."

export PATH="${PREFIX}/bin:$PATH"
echo ">>> Compiling and installing newlib"
cd "${NEWLIBDIR}"
check_error $? "Change directory failed."
./configure "--target=${TARGET}" "--prefix=${PREFIX}" "--program-prefix=${TARGET}-" "--disable-nls"
check_error $? "Error configuring NEWLIB."
make all install
check_error $? "Error compiling/installing NEWLIB."

echo ./configure "--target=${TARGET}" "--prefix=${PREFIX}" "--program-prefix=${TARGET}-" "--disable-nls"

echo
echo ">>> Cross-compiler for ${TARGET} installed."
