# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ASB
DIST_VERSION=0.61
inherit perl-module

DESCRIPTION="Unified cache handling interface"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-perl/Carp-Assert-0.200.0
	dev-perl/Class-Load
	dev-perl/Data-UUID
	dev-perl/Digest-JHash
	virtual/perl-Digest-MD5
	>=virtual/perl-File-Spec-0.800.0
	dev-perl/Hash-MoreUtils
	>=dev-perl/JSON-MaybeXS-1.3.3
	>=dev-perl/List-MoreUtils-0.130.0
	>=dev-perl/Log-Any-0.80.0
	>=dev-perl/Moo-1.3.0
	>=dev-perl/MooX-Types-MooseLike-0.230.0
	dev-perl/MooX-Types-MooseLike-Numeric
	virtual/perl-Storable
	dev-perl/String-RewritePrefix
	dev-perl/Task-Weaken
	>=dev-perl/Time-Duration-1.60.0
	>=dev-perl/Time-Duration-Parse-0.30.0
	virtual/perl-Time-HiRes
	>=dev-perl/Try-Tiny-0.50.0
"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/TimeDate
		virtual/perl-Test-Simple
		dev-perl/Test-Class
		dev-perl/Test-Deep
		dev-perl/Test-Exception
		dev-perl/Test-Warn
	)
"

PERL_RM_FILES=(
	t/author-{03-pod,file-driver,no-data-serializer,RequiredModules}.t
	t/smoke-Driver-{CacheCache,File-DepthZero,FastMmap,File,NonMoose}.t
	t/smoke-Driver-Subcache-{mirror,l1}_cache.t
	t/smoke-Null.t
	t/release-dependent.t
)
