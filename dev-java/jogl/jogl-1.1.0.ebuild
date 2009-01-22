# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

WANT_ANT_TASKS="ant-antlr"
JAVA_PKG_IUSE="cg source" #doc

inherit java-pkg-2 java-ant-2

DESCRIPTION="Java(TM) Binding fot the OpenGL(TM) API"
HOMEPAGE="https://jogl.dev.java.net"
SRC_URI="http://download.java.net/media/jogl/builds/archive/jsr-231-${PV}/${P}-src.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

COMMON_DEPEND="dev-java/ant-core
	>=dev-java/cpptasks-1.0_beta4-r2
	dev-java/gluegen
	cg? ( media-gfx/nvidia-cg-toolkit )
	virtual/opengl
	x11-libs/libX11
	x11-libs/libXxf86vm"

DEPEND=">=virtual/jdk-1.4
	app-arch/unzip
	${COMMON_DEPEND}"

RDEPEND=">=virtual/jre-1.4
	${COMMON_DEPEND}"
IUSE=""

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${A}
	epatch \
		"${FILESDIR}/${PV}/uncouple-gluegen.patch" \
		"${FILESDIR}/${PV}/fix-solaris-compiler.patch"
	#epatch "${FILESDIR}/${PV}/fix-solaris-compiler.patch"

	rm -R jogl/build/gensrc/classes/*

	#Should no longer be required
	#java-ant_rewrite-classpath gluegen/make/build.xml
	cd gluegen/make/lib
	rm -v *.jar || die
	java-pkg_jar-from cpptasks
}

src_compile() {
	cd make/
	local antflags="-Dantlr.jar=$(java-pkg_getjars --build-only antlr)"
	local gcp="$(java-pkg_getjars ant-core):$(java-config --tools)"

	local gluegen="-Dgluegen.jar=$(java-pkg_getjar gluegen gluegen.jar)"
	local gluegenrt="-Dgluegen-rt.jar=$(java-pkg_getjar gluegen gluegen-rt.jar)"

	use cg && antflags="${antflags} -Djogl.cg=1 -Dx11.cg.lib=/usr/lib"
	# -Dbuild.sysclasspath=ignore fails with missing ant dependencies.

	export ANT_OPTS="-Xmx1g"
	eant \
		-Dgentoo.classpath="${gcp}" \
		"${antflags}" "${gluegen}" "${gluegenrt}" \
		all
}

src_install() {
	#use doc && java-pkg_dojavadoc javadoc_public
	# Installed binary bundles a gluegen runtime but it's probably not worth it
	# but it's a bundled dep any way.
	use source && java-pkg_dosrc src/classes/*
	java-pkg_doso build/obj/*.so
	java-pkg_dojar build/*.jar
}
