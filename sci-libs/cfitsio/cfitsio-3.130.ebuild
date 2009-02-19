# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/cfitsio/cfitsio-3.130.ebuild,v 1.1 2009/02/18 11:54:01 bicatali Exp $

EAPI=2
inherit eutils fortran autotools

DESCRIPTION="C and Fortran library for manipulating FITS files"
HOMEPAGE="http://heasarc.gsfc.nasa.gov/docs/software/fitsio/fitsio.html"
SRC_URI="ftp://heasarc.gsfc.nasa.gov/software/fitsio/c/${PN}${PV//.}.tar.gz"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="doc fortran"

DEPEND="fortran? ( dev-lang/cfortran )"
RDEPEND=""

S="${WORKDIR}/${PN}"

pkg_setup() {
	if use fortran; then
		FORTRAN="gfortran g77 ifc"
		fortran_pkg_setup
	fi
}

src_prepare() {
	# avoid internal cfortran
	if use fortran; then
		sed -i \
			-e 's:"cfortran.h":<cfortran.h>:' \
			f77_wrap.h || die "sed fortran failed"
		mv cfortran.h cfortran.h.disabled
	fi
	epatch "${FILESDIR}"/${P}-autotools.patch
	eautoreconf
}

src_configure() {
	econf $(use_enable fortran)
}

src_install () {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc changes.txt README cfitsio.doc || die "dodoc failed"
	insinto /usr/share/doc/${PF}/examples
	doins cookbook.c testprog.c speed.c smem.c || die "install examples failed"
	use fortran && dodoc fitsio.doc && doins cookbook.f
	if use doc; then
		insinto /usr/share/doc/${PF}/
		doins quick.ps cfitsio.ps fpack.pdf
		use fortran && doins fitsio.ps
	fi
}
