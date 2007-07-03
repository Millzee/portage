# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="A standard XML processing API that allows you to stream XML data from and to your application."
HOMEPAGE="http://stax.codehaus.org/"
SRC_URI="http://dist.codehaus.org/${PN}/distributions/${PN}-src-${PV}.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND=">=virtual/jdk-1.4"

DEPEND="${RDEPEND}
		>=virtual/jdk-1.4
		app-arch/unzip"

S="${WORKDIR}"

EANT_DOC_TARGET="javadoc"
EANT_BUILD_TARGET="ri_bin_dist"

src_unpack(){
	unpack ${A}
	cd "${S}" || die "cd failed"
	epatch ${FILESDIR}/ant.patch
	for build in $(find "${S}" -name build*.xml );do
		java-ant_rewrite-classpath ${build}
	done
}

src_install() {
	java-pkg_newjar ${S}/build/stax-api-${PV}.jar stax-api.jar
	java-pkg_newjar ${S}/build/stax-${PV}-dev.jar stax-dev.jar

	if use doc; then
		java-pkg_dohtml *.html
		java-pkg_dojavadoc "${S}/build/javadoc"
	fi
	use source && java-pkg_dosrc src/*
}
