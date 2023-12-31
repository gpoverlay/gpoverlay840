# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=SPROUT
DIST_VERSION=1.00002
inherit perl-module

DESCRIPTION="Perl module enabling one to delete subroutines"

SLOT="0"
KEYWORDS="amd64 ~riscv x86 ~x64-macos"

RDEPEND="
	>=virtual/perl-Exporter-5.570.0
"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.0.20-perl-separator.patch
)
