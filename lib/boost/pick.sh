#!/bin/sh

# pick necessary boost header files

# TODO: support multi-arch
# x86/x64 requires:
#   include/boost/asio/detail/keyword_tss_ptr.hpp
# arm requires:
#   include/boost/asio/detail/impl/posix_tss_ptr.ipp
#   include/boost/asio/detail/posix_tss_ptr.hpp

dir=${0%/*}
test "$dir" = "$0" && dir=.

test -z "$1" && echo "$0 boost_dir [copy_to]" && exit 1
test ! -d "$1" && echo "$1 is not a directory" && exit 1

CXX="$YUNOS_ROOT/prebuilts/$XMAKE_COMPILER/linux-x86/$XMAKE_ARCH_TARGET/$XMAKE_TOOLCHAIN_NAME-$XMAKE_TOOLCHAIN_VERSION-glibc-$XMAKE_GLIBC_VERSION/bin/$XMAKE_TOOLCHAIN_NAME-g++"
#CXX="/home/solar/work/yunos.new/prebuilts/gcc/linux-x86/arm/arm-linux-gnueabi-4.9-glibc-2.20/bin/arm-linux-gnueabi-g++"
test -x "$CXX" || CXX=$(which g++)

boost=$1
dest=$(readlink -m "${2:-$dir/include}")
mkdir -p "$dest" || exit 1

SRCFILES=$(find "$dir/../../src" "$dir/src" -name "*.cpp")
CPPFLAGS="-I$dir/../websocketpp -I$dir/../rapidjson/include -I$boost"
CPPFLAGS="$CPPFLAGS -DBOOST_ASIO_DISABLE_BOOST_REGEX" #-DSIO_TLS

"$CXX" -std=c++11 $CPPFLAGS -M $SRCFILES | \
while read -r line; do
    line=${line%\\}
    set - $line
    while test $# -ne 0; do
        inc=${1#*/boost/}
        test "$1" != "$inc" && echo "boost/$inc"
        shift
    done
done | sort | uniq | (cd $boost; cpio -pdlm --quiet "$dest")
