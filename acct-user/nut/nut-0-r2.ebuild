# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="A user for the Network-UPS Tools"

ACCT_USER_GROUPS=( "nut" "uucp" )
ACCT_USER_HOME="/var/lib/nut"
ACCT_USER_ID="84"

acct-user_add_deps
