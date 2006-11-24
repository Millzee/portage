# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils java-ant-2 java-pkg-2

DESCRIPTION="StatSVN is a metrics-analysis tool for charting software evolution through analysis of Subversion source repositories."
HOMEPAGE="http://www.statsvn.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}-source.zip"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc source test"

COMMON_DEPEND="
	>=dev-java/jcommon-1.0.0
	>=dev-java/jfreechart-1.0.1"

DEPEND=">=virtual/jdk-1.4
	dev-java/ant-core
	app-arch/zip
	test? ( =dev-java/junit-3.8*)
	${COMMON_DEPEND}"

RDEPEND=">=virtual/jre-1.4
	>=dev-util/subversion-1.3.0
	${COMMON_DEPEND}"

src_unpack() {
	unpack ${A}

	cd ${S}/tests-src/net/sf/statsvn/input
	epatch ${FILESDIR}/${P}-test.patch

	cd ${S}/lib
	rm *.jar
	java-pkg_jar-from jcommon-1.0 jcommon.jar jcommon-1.0.0.jar
	java-pkg_jar-from jfreechart-1.0 jfreechart.jar jfreechart-1.0.1.jar
	use test && java-pkg_jar-from junit
}

src_compile() {
	eant dist $(use_doc)
}

src_install() {
	java-pkg_dojar dist/${PN}.jar
	java-pkg_dolauncher statsvn --jar ${PN}.jar

	use doc && java-pkg_dohtml -r doc/*
	use source && java-pkg_dosrc src/*
}

src_test() {
	ewarn "Note that the tests require you to be online."
	eant test
}

pkg_postinst() {
	elog "For instractions on how to use StatSVN see"
	elog "http://svn.statsvn.org/statsvnwiki/index.php/Main_Page"
}
