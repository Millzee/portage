# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/scret/scret-0.1.3-r1.ebuild,v 1.1 2009/02/13 20:35:06 carlo Exp $

ARTS_REQUIRED="never"

WANT_AUTOMAKE="1.6"

inherit kde

S="${WORKDIR}/ScoreReadingTrainer-${PV}"

DESCRIPTION="A musical score reading trainer."
HOMEPAGE="http://scret.sourceforge.net"
SRC_URI="mirror://sourceforge/scret/ScoreReadingTrainer-${PV}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~amd64"
IUSE=""

need-kde 3.5

PATCHES=( "${FILESDIR}/score-0.1.3-desktop-file.diff" )


src_unpack(){
	kde_src_unpack
	rm -f "${S}"/configure
}
