# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="A interpreted language mainly used for games"
HOMEPAGE="http://squirrel-lang.org/"
SRC_URI="mirror://sourceforge/squirrel/squirrel_${PV}_stable.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

DEPEND=""
RDEPEND=""

S="${WORKDIR}/SQUIRREL2"

src_compile() {
	if use amd64 ; then
		emake sq64 || die "emake failed"
	else
		emake || die "emake failed"
	fi
}

src_install() {
	insinto /usr
	doins -r bin include lib || die "copying files failed"
	dodoc HISTORY README || die "copying documentation failed"

	if use doc ; then
		insinto /usr/share/doc/${PF}
		doins doc/{squirrel2.pdf,sqstdlib2.pdf} || die "copying documentation failed"
	fi

	if use examples ; then
		insinto /usr/share/doc/${PF}/samples
		doins -r etc samples/* || die "copying examples failed"
	fi
}
