# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools subversion games

DESCRIPTION="Doom port designed to act identically to the original game"
HOMEPAGE="http://www.chocolate-doom.org/"
ESVN_REPO_URI="https://chocolate-doom.svn.sourceforge.net/svnroot/chocolate-doom/trunk/chocolate-doom"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="server"

DEPEND=">=media-libs/libsdl-1.1.3
	media-libs/sdl-mixer
	media-libs/sdl-net"

src_unpack() {
	subversion_src_unpack
	cd "${S}"

	# Change default search path for IWAD
	sed -i \
		-e "s:/usr/share/games/doom:${GAMES_DATADIR}/doom-data:" \
		src/d_iwad.c || die "sed main.c failed"

	sed -i \
		-e "s:^gamesdir =.*:gamesdir = ${GAMES_BINDIR}:" \
		setup/Makefile.am || die "sed Makefile.am failed"
}

src_compile() {

	eautoreconf

	egamesconf \
		--disable-sdltest \
		--disable-dependency-tracking \
		|| die "egamesconf failed"

	emake || die "emake failed"
}

src_install() {
	dogamesbin src/${PN} || die "dogamesbin ${PN} failed"
	dogamesbin setup/chocolate-setup || die "dogamesbin chocolate-setup failed"
	if use server ; then
		dogamesbin src/chocolate-server || die "dogamesbin chocolate-server failed"
	fi

	doicon data/${PN}.png || die "doicon failed"
	make_desktop_entry ${PN} "Chocolate Doom"
	doicon data/chocolate-setup.png || die "doicon failed"
	make_desktop_entry chocolate-setup "Chocolate Doom Setup" chocolate-setup.png

	doman man/${PN}.6 || die "doman failed"
	dodoc AUTHORS BUGS ChangeLog HACKING NEWS README TODO || die "dodoc failed"

	dodir "${GAMES_DATADIR}/doom-data" || die "dodir failed"

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst

	echo
	elog "To play the original Doom levels, place doom.wad and/or doom2.wad"
	elog "into ${GAMES_DATADIR}/doom-data, then run: ${PN}"
	elog
	elog "To configure game options run:  chocolate-setup"
	echo
}
