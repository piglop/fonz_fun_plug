#!/bin/bash

CWD=$(pwd)
FUNPKG=$CWD/funpkg
#TAR=$(which tar-1.13)
X=$(readlink -f $1)

die()
{
    cat <<EOF
FATAL: $@
EOF
    exit 1
}

[ -d "$X" ] || die "Usage: $(basename $0) <subdir>"
[ -r "$X/packages.txt" ] || die "$X: packages.txt missing"
[ -x "$FUNPKG" ] || die "funpkg not found"
#[ -x "$TAR" ] || die "tar-1.13 not found"
[ $(id -u) -eq 0 ] || die "Must be root!"

pkg_dirlist=(
    $CWD/../packages
    $CWD/../extra-packages/All
)

find_pkg()
{   
    for pkg_dir_ in ${pkg_dirlist[@]}; do
	pkg_=$(cd $pkg_dir_; ls -1 $1-*.tgz 2>/dev/null | egrep "$1"'-[^-]*-[^-]*.tgz$' | tail -n 1)
	[ -f "$pkg_dir_/$pkg_" ] || continue
	echo "$pkg_dir_/$pkg_"
	return 0
    done
    die "$1: No package found"
}

install_pkg()
{
    _cmd="/bin/sh $FUNPKG -D $D -i $1"
    echo $_cmd
    eval $_cmd
}


D=$X/sysroot
echo "Installing to $D ..."
rm -rf $D
mkdir -vp $D

for pkg in $(cat $X/packages.txt); do
    f=$(find_pkg $pkg)
    install_pkg $f
done

echo

# customize
export D X
if [ -x "$X/customize.sh" ]; then
    echo "Customize ..."
    $X/customize.sh
fi

# archive
echo "Creating archive ..."
N=$(basename $X)
( cd $D; find | cpio -o -H newc | gzip -c -9 ) >$X/$N-initramfs.gz
echo
du -cms $X/$N-initramfs.gz

