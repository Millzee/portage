# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="message board and file sharing client for freenet network"
HOMEPAGE="http://jtcfrost.sourceforge.net/"
MY_V="19-Jul-2007"
MY_P="${PN}-${MY_V}"
SRC_URI=" mirror://sourceforge/jtcfrost/${MY_P}-source.zip
	mirror://sourceforge/jtcfrost/${MY_P}.zip"
RESTRICT="userpriv mirror"
LICENSE="GPL-2"
IUSE=""
SLOT="0"
KEYWORDS="~x86"
RDEPEND=">=virtual/jdk-1.5
	|| ( net-p2p/freenet
	net-p2p/freenet-bin )"
DEPEND=">=virtual/jdk-1.5
	dev-java/ant
	app-arch/unzip"
S="${WORKDIR}/${PN}-wot"

pkg_setup() {
	enewgroup frost
}

src_unpack() {
	unpack ${A}
	cp -R lib ${S}/
}

src_compile() {
	ant release
}

src_install() {
	into /opt/frost
	cp -R ${S}/build/dist/* ${D}/opt/frost/
	fowners :frost /opt/frost /opt/frost/config /opt/frost/downloads /opt/frost/store /opt/frost/exec
}

pkg_postinst() {
	chmod  g+w -R /opt/frost/config /opt/frost/downloads /opt/frost/store /opt/frost/exec
	einfo "Start frost with sh /opt/frost/frost.sh (you have to be in the frost-group)."
}
