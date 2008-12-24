# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

DESCRIPTION="HTML documentation for Python"
HOMEPAGE="http://www.python.org/doc/"
SRC_URI="http://www.python.org/ftp/python/doc/${PV}/python-${PV}-docs-html.tar.bz2"

LICENSE="PSF-2.2"
SLOT="3.0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~sparc-fbsd ~x86 ~x86-fbsd"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}/python-docs-html"

src_install() {
	docinto html
	cp -R [a-z]* _static "${D}/usr/share/doc/${PF}/html"
}

pkg_preinst() {
	dodir /etc/env.d
	echo "PYTHONDOCS=/usr/share/doc/${PF}/html/library" > "${D}/etc/env.d/50python-docs"
}
