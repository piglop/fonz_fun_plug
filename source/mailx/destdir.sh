make PREFIX=${CPREFIX} MANDIR=${CPREFIX}/share/man SYSCONFDIR=${CSYSCONFDIR} MAILSPOOL=${CPREFIX}/var/mail SENDMAIL=${CPREFIX}/bin/sendmail \
	UCBINSTALL=${CPREFIX}/bin/install DESTDIR=$D install
