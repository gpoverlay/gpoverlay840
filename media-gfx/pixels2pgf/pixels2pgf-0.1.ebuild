# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Convert pixel images (e.g. QRCode) to PGF/Tikz rectangles"
HOMEPAGE="https://github.com/projg2/pixels2pgf/"
SRC_URI="https://github.com/projg2/pixels2pgf/releases/download/${P}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-libs/libsdl:0=
	media-libs/sdl-image:0="
DEPEND="${RDEPEND}"
