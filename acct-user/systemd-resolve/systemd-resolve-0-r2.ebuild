# Copyright 2019-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

ACCT_USER_ID=193
ACCT_USER_GROUPS=( systemd-resolve )

acct-user_add_deps
