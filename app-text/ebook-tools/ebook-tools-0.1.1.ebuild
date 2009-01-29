# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/ebook-tools/ebook-tools-0.1.1.ebuild,v 1.1 2009/01/28 18:42:42 alexxy Exp $

inherit cmake-utils

DESCRIPTION="Tools for accessing and converting various ebook file formats."
HOMEPAGE="http://sourceforge.net/projects/ebook-tools"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/libxml2
	dev-libs/libzip"
RDEPEND="${DEPEND}"

src_install() {
	cmake-utils_src_install
	dodoc INSTALL README TODO
}
