
make \
	BOOT_CFLAGS="-g -O2 -msoft-float" \
	LDFLAGS_FOR_BUILD="$LDFLAGS" \
	LDFLAGS_FOR_TARGET="$LDFLAGS" \
	LDFLAGS="$LDFLAGS" \
	STAGE1_CFLAGS="-march=arm"


