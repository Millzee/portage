# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Decoder for onlinetvrecorder.com (German)"
HOMEPAGE="http://www.onlinetvrecorder.com/"
SRC_URI="http://www.onlinetvrecorder.com/downloads/${PN}-linux-static-v${PV}.tar.bz2"
LICENSE="as-is"

SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="X"

RDEPEND="X? ( gnome-base/libglade
		dev-python/pygtk )"
DEPEND=""

RESTRICT="strip"
S="${WORKDIR}/otrdecoder-bin-linux-static-v${PV}"

src_install() {
	dobin otrdecoder
	if use X; then
		insinto /usr/share/${P}
		doins decoder.glade

		sed -i -e "s:xml = gtk.glade.XML(join(decoderpath,'decoder.glade')):xml = gtk.glade.XML(join('/usr/share/${P}/','decoder.glade')):" \
			otrdecoder-gui
		dobin otrdecoder-gui
	fi

	dodoc README.OTR
}
