# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/vanilla-sources/vanilla-sources-2.6.26.7.ebuild,v 1.4 2008/11/09 18:14:15 klausman Exp $

K_NOUSENAME="yes"
K_NOSETEXTRAVERSION="yes"
K_SECURITY_UNSUPPORTED="1"
ETYPE="sources"
inherit kernel-2
detect_version

DESCRIPTION="Full sources for the Linux kernel"
HOMEPAGE="http://www.kernel.org"
SRC_URI="${KERNEL_URI}"

KEYWORDS="alpha ~amd64 ~arm hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""
