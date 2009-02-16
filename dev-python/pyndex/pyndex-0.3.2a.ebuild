# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyndex/pyndex-0.3.2a.ebuild,v 1.8 2009/02/15 22:51:16 patrick Exp $

inherit distutils

MY_PN="Pyndex"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Pyndex is a simple and fast full-text indexer (aka search engine) implemented in Python. It uses Metakit as its storage back-end."
HOMEPAGE="http://www.divmod.org/Pyndex/index.html"
SRC_URI="mirror://sourceforge/pyndex/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ia64 s390 x86"
IUSE=""

DEPEND=">=dev-lang/python-2.2
	>=dev-db/metakit-2.4.9.2"

S=${WORKDIR}/${MY_P}
