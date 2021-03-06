# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/beast/beast-0.7.1-r2.ebuild,v 1.1 2009/07/21 17:40:19 ssuominen Exp $

EAPI=2
inherit autotools eutils fdo-mime

IUSE=""

DESCRIPTION="BEAST - the Bedevilled Sound Engine"
HOMEPAGE="http://beast.gtk.org"
SRC_URI="http://dist.testbit.eu/beast/v${PV%.[0-9]}/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2.1"
KEYWORDS="~amd64 ~ppc ~x86"
SLOT="0"

RDEPEND=">=dev-libs/glib-2.0
	>=x11-libs/gtk+-2.12
	>=sys-libs/zlib-1.1.3
	>=dev-scheme/guile-1.6
	>=media-libs/libart_lgpl-2.3.8
	>=gnome-base/libgnomecanvas-2.4
	>=media-libs/libogg-1.0
	>=media-libs/libvorbis-1.0
	media-sound/madplay"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	dev-lang/perl
	media-libs/ladspa-cmt
	media-libs/ladspa-sdk
	>=dev-util/intltool-0.35"


src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/100_deprecated.diff"
	epatch "${FILESDIR}/203_gcc45.patch"
	epatch "${FILESDIR}/210_volatile.diff"
	epatch "${FILESDIR}/300-desktop_file.patch"
	epatch "${FILESDIR}/400-format-security.patch"

	# Remove useless dist check that makes tests fail
#	sed -i "s/\.PHONY:.*/.PHONY:/" Makefile.decl || die "sed failed"

	intltoolize --force --automake --copy || die "intltoolize failed"
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	# dont install new mime files !
	for i in subclasses XMLnamespaces aliases globs magic mime.cache\
		audio/x-bsewave.xml audio/x-bse.xml; do
		rm -f "${D}/usr/share/mime/${i}"
	done

	dodoc AUTHORS ChangeLog NEWS README TODO
}

pkg_postinst() {
	fdo-mime_mime_database_update
}
