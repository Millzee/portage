# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

inherit perl-module

DESCRIPTION="Email::Valid which allows dot before at mark"
HOMEPAGE="http://search.cpan.org/dist/${PN}/"
SRC_URI="mirror://cpan/authors/id/M/MI/MIYAGAWA/${P}.tar.gz"
LICENSE="|| ( Artistic GPL-2 )"
RESTRICT="nomirror"

SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 ppc-macos s390 sh sparc sparc-fbsd x86 x86-fbsd"

IUSE=""
DEPEND="
	>=dev-perl/Email-Valid-0.13
"
