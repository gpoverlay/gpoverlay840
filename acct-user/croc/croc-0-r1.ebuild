# Copyright 2019-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="User for net-misc/croc"
ACCT_USER_ID=310
ACCT_USER_GROUPS=( ${PN} )

acct-user_add_deps
