# Copyright 2019-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for the net-misc/vlmcsd server"
ACCT_USER_ID=-1
ACCT_USER_GROUPS=( vlmcsd )

acct-user_add_deps
