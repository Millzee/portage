# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit java-pkg-2

IUSE="aac cddb flac gtk mp3 vorbis"

DESCRIPTION="jRipper, a Java frontend to CD ripper and encoder tools"
SRC_URI="http://dronten.googlepages.com/${P}.zip"
HOMEPAGE="http://dronten.googlepages.com/jripper"

LICENSE="GPL-2"
KEYWORDS="~amd64"
SLOT="0"

RDEPEND=">=virtual/jre-1.5
	virtual/cdrtools
	aac? ( media-libs/faac media-libs/faad2 )
	cddb? ( media-libs/libcddb )
	flac? ( media-libs/flac )
	gtk? ( >=x11-libs/gtk+-2 )
	mp3? ( media-sound/lame )
	vorbis? ( media-sound/vorbis-tools )"
DEPEND=">=virtual/jdk-1.5
	app-arch/unzip"

S=${WORKDIR}

src_unpack() {
	unpack ${A}
	unzip -q "${WORKDIR}/${PN}.jar"
	rm "${WORKDIR}/${PN}.jar"
	cd "${S}"

	# delete testcode
	rm -rf junit com/googlepages/dronten/jripper/test
	# delete junit license
	rm -rf license.junit.html

	# delete pre-built code
	find . -type f -name '*.class' | xargs rm
}

src_compile() {
	ejavac $(find com/ -name '*.java') || die "compile failed"
	find . -type f -name '*.java' | xargs rm
	find com | xargs jar cf ${PN}.jar
}

src_install() {
	java-pkg_dojar "${PN}.jar"

	java-pkg_dolauncher "${PN}" \
		--main com.googlepages.dronten.jripper.JRipper

	doicon "${FILESDIR}/${PN}.png"
	domenu "${FILESDIR}/${PN}.desktop"
}
