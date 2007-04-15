inherit eutils
gmpc-plugin_pkg_setup()
{
        if [[ -n "${GTK_REQUIRES}" ]] && ! built_with_use '=x11-libs/gtk+-2*' "${GTK_REQUIRES}"; then
		eerror "You must build =x11-libs/gtk+-2.x with ${GTK_REQUIRES} USE flag."
		die "Please re-emerge =x11-libs/gtk+-2.x with ${GTK_REQUIRES} USE flag."
	fi
}

if [[ "${PN##*-}" == "live" ]]; then
	inherit subversion autotools
	DEPEND="${DEPEND}
		media-sound/gmpc-live
		dev-libs/libxml2
		!${CATEGORY}/${PN/-live}"
	RDEPEND="${DEPEND}"
	if [[ -z ${ESVN_REPO_URI} ]]; then
		if [[ -z ${GMPC_PLUGIN} ]]; then
			GMPC_PLUGIN="${PN%-live}"
			GMPC_PLUGIN="${GMPC_PLUGIN#gmpc-}"
		fi

		ESVN_REPO_URI="https://svn.musicpd.org/gmpc/plugins/gmpc-${GMPC_PLUGIN}/trunk"
	fi

	gmpc-plugin_src_unpack() {
		subversion_src_unpack
		AT_NOELIBTOOLIZE="yes" eautoreconf
	}
	EXPORT_FUNCTIONS src_unpack
else
	## Depend against reverse dependency
	DEPEND="${DEPEND}
		>=media-sound/gmpc-${PV}
		!${CATEGORY}/${PN}-live"
	RDEPEND="${DEPEND}"
	
	## In the case that it's given an odd name
	if [[ -n "${GMPC_PLUGIN}" ]]; then
		GMPC_PLUGIN="gmpc-${GMPC_PLUGIN}-${PV}"
	else
		GMPC_PLUGIN="${P}"
	fi

	SRC_URI="http://download.sarine.nl/gmpc-${PV}/plugins/${GMPC_PLUGIN}.tar.gz"
	S="${WORKDIR}/${GMPC_PLUGIN}"

	## Without this, portage keeps appending to $GMPC_PLUGIN
	unset GMPC_PLUGIN

	gmpc-plugin_src_compile() {
		cd "${S}"
		econf || die "died configuring gmpc plugin"
		emake || die "died making gmpc plugin"
	}

	EXPORT_FUNCTIONS src_compile
fi

gmpc-plugin_src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
}

EXPORT_FUNCTIONS src_install pkg_setup
