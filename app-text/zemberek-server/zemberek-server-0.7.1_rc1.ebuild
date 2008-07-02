# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1
inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="A Turkish spell checker server based on Zemberek NLP library"
HOMEPAGE="http://code.google.com/p/zemberek/"
SRC_URI="http://zemberek.googlecode.com/files/${P}.tar.gz"

LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS="~amd64"
S="${WORKDIR}"
IUSE=""

CDEPEND="dev-java/zemberek
	 dev-java/dbus-java
	 dev-java/mina-core"

RDEPEND="${CDEPEND}
	dev-java/slf4j-nop
	>=virtual/jre-1.5"

DEPEND="${CDEPEND}
	>=virtual/jdk-1.5"

EANT_BUILD_TARGET="dist"

pkg_setup() {
	! built_with_use zemberek linguas_tr \
	&& die "Zemberek should be built with Turkish language support"
	java-pkg-2_pkg_setup
}

src_unpack() {
	unpack ${A}
	cd "${S}"/lib || die
	rm -v *.jar
	java-pkg_jarfrom zemberek zemberek2-cekirdek.jar
	java-pkg_jarfrom zemberek zemberek2-tr.jar
	java-pkg_jarfrom dbus-java dbus.jar
	java-pkg_jarfrom mina-core
}

src_install() {
	java-pkg_newjar dist/${P}.jar ${PN}.jar
	java-pkg_dolauncher zemberek-server \
		--java_args \
		"-Xverify:none -Xms12m -Xmx14m -DConfigFile=/etc/zemberek-server.ini" \
		--pre "${FILESDIR}"/pre \
		--main net.zemberekserver.server.ZemberekServer
	java-pkg_register-dependency slf4j-nop
	doinitd "${FILESDIR}"/zemberek-server
	insinto /etc/dbus-1/system.d
	doins dist/config/zemberek-server.conf
	insinto /etc
	newins config/conf.ini zemberek-server.ini
}
