# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="doc source"
inherit eutils java-pkg-2 flag-o-matic

DESCRIPTION="A selection of libraries for Java"
HOMEPAGE="http://www.matthew.ath.cx/projects/java/"
SRC_URI="http://www.matthew.ath.cx/projects/java/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=virtual/jre-1.5"
DEPEND=">=virtual/jdk-1.5"

src_compile() {
	append-flags -fPIC
	emake -j1 JCFLAGS="$(java-pkg_javac-args)" all $(use doc && echo doc)
}

src_install() {
	java-pkg_newjar cgi-0.5.jar cgi.jar
	java-pkg_newjar debug-disable-1.1.jar debug-disable.jar
	java-pkg_newjar debug-enable-1.1.jar debug-enable.jar
	java-pkg_newjar hexdump-0.1.jar hexdump.jar
	java-pkg_newjar io-0.1.jar io.jar
	java-pkg_newjar unix-0.2.jar unix.jar
	java-pkg_doso libcgi-java.so
	java-pkg_doso libunix-java.so
	dodoc INSTALL changelog README || die
	use source && java-pkg_dosrc cx/
	use doc && java-pkg_dojavadoc doc
}
