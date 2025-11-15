# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="Vlmcsd (KMS Emulator in C)"
HOMEPAGE="https://github.com/Wind4/vlmcsd"

LICENSE=""
SLOT="0"
IUSE="systemd"

DEPEND="acct-group/vlmcsd
	acct-user/vlmcsd
	systemd? ( sys-apps/systemd )
	"
# compile used git not only on 9999
BDEPEND="dev-vcs/git"

if [[ ${PV} = "9999" ]]; then
    inherit git-r3
    EGIT_REPO_URI="https://github.com/Wind4/${PN}.git"
else
    SRC_URI="https://github.com/Wind4/vlmcsd/archive/svn${PV}.tar.gz -> ${P}.tar.gz"    
    KEYWORDS="~amd64 ~x86"
    S="${WORKDIR}/${PN}-svn${PV}"

    PATCHES=(
	"${FILESDIR}"/fix_dangling_pointer.patch
        "${FILESDIR}"/remove-max-thread-pull-64.patch
        "${FILESDIR}"/strncopy-fix.patch
    )

fi


src_prepare() {
	default
	cp -f "${FILESDIR}"/vlmcsd.kmd "${S}/etc/"
	cp -f "${FILESDIR}"/README.md "${S}/"
}
src_compile() {
	emake
	emake man
}

src_install() {
	dobin ./bin/vlmcsd
	dobin ./bin/vlmcs

	dodir /etc/vlmcsd
	insinto /etc/vlmcsd
	doins ./etc/vlmcsd.ini
	doins ./etc/vlmcsd.kmd

	use systemd && systemd_dounit "${FILESDIR}"/vlmcsd.service

	newinitd "${FILESDIR}"/vlmcsd.openrc vlmcsd

	doman ./man/vlmcs.1
	doman ./man/vlmcsd.ini.5
	doman ./man/vlmcsd.7
	doman ./man/vlmcsd.8
}
