# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/python/python-2.5.2-r1.ebuild,v 1.1 2008/04/18 22:23:25 hawking Exp $

# NOTE about python-portage interactions :
# - Do not add a pkg_setup() check for a certain version of portage
#   in dev-lang/python. It _WILL_ stop people installing from
#   Gentoo 1.4 images.

EAPI=1

inherit eutils autotools flag-o-matic python multilib versionator toolchain-funcs alternatives libtool

# we need this so that we don't depends on python.eclass
PYVER_MAJOR=$(get_major_version)
PYVER_MINOR=$(get_version_component_range 2)
PYVER="${PYVER_MAJOR}.${PYVER_MINOR}"

MY_PV="${PV/_beta/b}"
MY_P="Python-${MY_PV}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Python is an interpreted, interactive, object-oriented programming language."
HOMEPAGE="http://www.python.org/"
SRC_URI="http://www.python.org/ftp/python/2.6/${MY_P}.tar.bz2
	http://dev.gentoo.org/~hawking/py3k/patches/python-gentoo-patches-${PV/_b*/}.tar.bz2"

LICENSE="PSF-2.2"
SLOT="2.6"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~sparc-fbsd ~x86 ~x86-fbsd"
IUSE="ncurses gdbm ssl readline tk berkdb bootstrap ipv6 build ucs2 sqlite doc +threads examples elibc_uclibc wininst"

# NOTE: dev-python/{elementtree,celementtree,pysqlite,ctypes,cjkcodecs}
#       do not conflict with the ones in python proper. - liquidx

DEPEND=">=app-admin/eselect-python-20080620
	>=sys-libs/zlib-1.1.3
	!build? (
		sqlite? ( >=dev-db/sqlite-3 )
		tk? ( >=dev-lang/tk-8.0 )
		ncurses? ( >=sys-libs/ncurses-5.2
					readline? ( >=sys-libs/readline-4.1 ) )
		berkdb? ( >=sys-libs/db-3.1 )
		gdbm? ( sys-libs/gdbm )
		ssl? ( dev-libs/openssl )
		doc? ( dev-python/python-docs:2.5 )
		dev-libs/expat
	)"

# NOTE: changed RDEPEND to PDEPEND to resolve bug 88777. - kloeri
# NOTE: added blocker to enforce correct merge order for bug 88777. - zmedico

PDEPEND="${DEPEND} app-admin/python-updater"
PROVIDE="virtual/python"

src_unpack() {
	unpack ${A}
	cd "${S}"

	if tc-is-cross-compiler ; then
		[[ $(python -V 2>&1) != "Python ${PV}" ]] && \
			die "Crosscompiling requires the same host and build versions."
		epatch "${FILESDIR}"/python-2.6-test-cross.patch
	else
		rm "${WORKDIR}/${PV/_b*/}"/*_all_crosscompile.patch
	fi

	EPATCH_SUFFIX="patch" epatch "${WORKDIR}/${PV/_b*/}"
	sed -i -e "s:@@GENTOO_LIBDIR@@:$(get_libdir):g" \
		Lib/distutils/command/install.py \
		Lib/distutils/sysconfig.py \
		Lib/site.py \
		Makefile.pre.in \
		Modules/Setup.dist \
		Modules/getpath.c \
		setup.py || die

	# fix os.utime() on hppa. utimes it not supported but unfortunately reported as working - gmsoft (22 May 04)
	# PLEASE LEAVE THIS FIX FOR NEXT VERSIONS AS IT'S A CRITICAL FIX !!!
	[ "${ARCH}" = "hppa" ] && sed -e 's/utimes //' -i "${S}"/configure

	if ! use wininst; then
		# remove microsoft windows executables
		rm Lib/distutils/command/wininst-*.exe
	fi

	eautoreconf
}

src_configure() {
	# disable extraneous modules with extra dependencies
	if use build; then
		export PYTHON_DISABLE_MODULES="readline pyexpat dbm gdbm bsddb _curses _curses_panel _tkinter _sqlite3"
		export PYTHON_DISABLE_SSL=1
	else
		# dbm module can link to berkdb or gdbm
		# defaults to gdbm when both are enabled, #204343
		local disable
		use berkdb   || use gdbm || disable="${disable} dbm"
		use berkdb   || disable="${disable} bsddb"
		use gdbm     || disable="${disable} gdbm"
		use ncurses  || disable="${disable} _curses _curses_panel"
		use readline || disable="${disable} readline"
		use sqlite   || disable="${disable} sqlite3"
		use ssl      || export PYTHON_DISABLE_SSL=1
		use tk       || disable="${disable} _tkinter"
		export PYTHON_DISABLE_MODULES="${disable}"
	fi
	einfo "Disabled modules: $PYTHON_DISABLE_MODULES"
}

src_compile() {
	filter-flags -malign-double

	# Seems to no longer be necessary
	#[ "${ARCH}" = "amd64" ] && append-flags -fPIC
	[ "${ARCH}" = "alpha" ] && append-flags -fPIC

	# http://bugs.gentoo.org/show_bug.cgi?id=50309
	if is-flag -O3; then
	   is-flag -fstack-protector-all && replace-flags -O3 -O2
	   use hardened && replace-flags -O3 -O2
	fi

	export OPT="${CFLAGS}"

	local myconf

	# super-secret switch. don't use this unless you know what you're
	# doing. enabling UCS2 support will break your existing python
	# modules
	use ucs2 \
		&& myconf="${myconf} --enable-unicode=ucs2" \
		|| myconf="${myconf} --enable-unicode=ucs4"

	use threads \
		&& myconf="${myconf} --with-threads" \
		|| myconf="${myconf} --without-threads"

	src_configure

	if tc-is-cross-compiler ; then
		OPT="-O1" CFLAGS="" LDFLAGS="" CC="" \
		./configure || die "cross-configure failed"
		emake python Parser/pgen || die "cross-make failed"
		mv python hostpython
		mv Parser/pgen Parser/hostpgen
		make distclean
		sed -i \
			-e '/^HOSTPYTHON/s:=.*:=./hostpython:' \
			-e '/^HOSTPGEN/s:=.*:=./Parser/hostpgen:' \
			Makefile.pre.in || die
	fi

	# export CXX so it ends up in /usr/lib/python2.x/config/Makefile
	tc-export CXX

	# set LDFLAGS so we link modules with -lpython2.5 correctly.
	# Needed on FreeBSD unless python2.5 is already installed.
	# Please query BSD team before removing this!
	append-ldflags "-L."

	econf \
		--with-fpectl \
		--enable-shared \
		`use_enable ipv6` \
		--infodir='${prefix}'/share/info \
		--mandir='${prefix}'/share/man \
		--with-libc='' \
		${myconf} || die
	emake || die "Parallel make failed"
}

src_install() {
	dodir /usr
	src_configure
	make DESTDIR="${D}" altinstall maninstall || die

	mv "${D}"/usr/bin/python${PYVER}-config "${D}"/usr/bin/python-config-${PYVER}

	# Fix slotted collisions
	mv "${D}"/usr/bin/pydoc "${D}"/usr/bin/pydoc${PYVER}
	mv "${D}"/usr/bin/idle "${D}"/usr/bin/idle${PYVER}
	mv "${D}"/usr/share/man/man1/python.1 \
		"${D}"/usr/share/man/man1/python${PYVER}.1
	rm -f "${D}"/usr/bin/smtpd.py

	# While we're working on the config stuff... Let's fix the OPT var
	# so that it doesn't have any opts listed in it. Prevents the problem
	# with compiling things with conflicting opts later.
	dosed -e 's:^OPT=.*:OPT=-DNDEBUG:' \
			/usr/$(get_libdir)/python${PYVER}/config/Makefile

	if use build ; then
		rm -rf "${D}"/usr/$(get_libdir)/python${PYVER}/{test,encodings,email,lib-tk,bsddb/test}
	else
		use elibc_uclibc && rm -rf "${D}"/usr/$(get_libdir)/python${PYVER}/{test,bsddb/test}
		use berkdb || rm -rf "${D}"/usr/$(get_libdir)/python${PYVER}/bsddb
		use tk || rm -rf "${D}"/usr/$(get_libdir)/python${PYVER}/lib-tk
	fi

	prep_ml_includes usr/include/python${PYVER}

	# The stuff below this line extends from 2.1, and should be deprecated
	# in 2.3, or possibly can wait till 2.4

	# seems like the build do not install Makefile.pre.in anymore
	# it probably shouldn't - use DistUtils, people!
	insinto /usr/$(get_libdir)/python${PYVER}/config
	doins "${S}"/Makefile.pre.in

	if use examples ; then
		mkdir -p "${D}"/usr/share/doc/${P}/examples
		cp -r "${S}"/Tools "${D}"/usr/share/doc/${P}/examples
	fi

	newinitd "${FILESDIR}/pydoc.init" pydoc-${SLOT}
	newconfd "${FILESDIR}/pydoc.conf" pydoc-${SLOT}
}

pkg_postrm() {
	eselect python update --ignore ${SLOT}

	python_mod_cleanup /usr/lib/python${PYVER}
	[[ "$(get_libdir)" == "lib" ]] || \
		python_mod_cleanup /usr/$(get_libdir)/python${PYVER}
}

pkg_postinst() {
	local myroot
	myroot="$(echo "${ROOT}" | sed 's:/$::')"

	# Update symlink temporarily to for byte-compiling.
	eselect python update
	python_version

	python_mod_optimize
	python_mod_optimize -x "(site-packages|test)" \
						/usr/lib/python${PYVER}
	[[ "$(get_libdir)" == "lib" ]] || \
		python_mod_optimize -x "(site-packages|test)" \
							/usr/$(get_libdir)/python${PYVER}

	# Update symlink back to old version.
	# Remove this after testing is done.
	eselect python update --ignore ${SLOT}

	echo
	ewarn "WARNING!"
	ewarn "This version of Python is experimental."
	ewarn "Thus symlinks haven't been updated."
	ewarn "/usr/bin/python is still linked to your old Python installation."
	ewarn "Please don't file bugs related to this Python version to Gentoo bugzilla."
	ewarn "You can send them to hawking@gentoo.org"
	ebeep 5
}

src_test() {
	# Tests won't work when cross compiling
	if tc-is-cross-compiler ; then
		elog "Disabling tests due to crosscompiling."
		return
	fi

	# PYTHON_DONTCOMPILE=1 breaks test_import
	unset PYTHON_DONTCOMPILE

	#skip all tests that fail during emerge but pass without emerge:
	#(See bug# 67970)
	local skip_tests="distutils global httpservers mimetools minidom mmap posix pyexpat sax strptime subprocess syntax tcl time urllib urllib2 webbrowser xml_etree"

	# test_pow fails on alpha.
	# http://bugs.python.org/issue756093
	[[ ${ARCH} == "alpha" ]] && skip_tests="${skip_tests} pow"

	for test in ${skip_tests} ; do
		mv "${S}"/Lib/test/test_${test}.py "${T}"
	done

	# rerun failed tests in verbose mode (regrtest -w)
	EXTRATESTOPTS="-w" make test || die "make test failed"

	for test in ${skip_tests} ; do
		mv "${T}"/test_${test}.py "${S}"/Lib/test/test_${test}.py
	done

	elog "Portage skipped the following tests which aren't able to run from emerge:"
	for test in ${skip_tests} ; do
		elog "test_${test}.py"
	done

	elog "If you'd like to run them, you may:"
	elog "cd /usr/lib/python${PYVER}/test"
	elog "and run the tests separately."
}
