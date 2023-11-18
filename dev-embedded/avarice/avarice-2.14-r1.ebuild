# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="Interface for GDB to Atmel AVR JTAGICE in circuit emulator"
HOMEPAGE="https://avarice.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=(
	"${FILESDIR}"/${P}-broken-__unused-macro.patch
	"${FILESDIR}"/${P}-implicit-function-declarations.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# bug #788295
	append-cxxflags -std=c++14

	default
}

src_install() {
	default
	dodoc doc/*.txt
}