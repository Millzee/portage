# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/cdfs/cdfs-2.6.27.ebuild,v 1.1 2009/02/02 16:02:51 drizzt Exp $

inherit eutils linux-mod

DESCRIPTION="A file system for Linux systems that 'exports' all tracks and boot images on a CD as normal files."
HOMEPAGE="http://www.elis.rug.ac.be/~ronsse/cdfs/"
SRC_URI="http://www.elis.rug.ac.be/~ronsse/cdfs/download/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RDEPENDS=""
DEPENDS=""

MODULE_NAMES="cdfs(fs)"
CONFIG_CHECK="BLK_DEV_LOOP"
BUILD_TARGETS="all"
BUILD_PARAMS="KDIR=\"${KERNEL_DIR}\""

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${PN}-2.6.19-kernel-2.6.22.patch
	epatch "${FILESDIR}"/${P}-kernel-2.6.28.patch
}
