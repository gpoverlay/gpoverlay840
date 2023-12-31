# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

FORTRAN_NEEDED=fortran

inherit fcaps fortran-2 linux-info toolchain-funcs

DESCRIPTION="A performance-oriented tool suite for x86 multicore environments"
HOMEPAGE="https://github.com/rrze-likwid/likwid"
SRC_URI="https://ftp.fau.de/pub/likwid/${P}.tar.gz"

LICENSE="GPL-3+ BSD MIT"

SLOT="0"
KEYWORDS="~amd64" # upstream partial support exists for x86 arm arm64
IUSE="fortran"

CDEPEND="dev-lang/perl"

RDEPEND="${CDEPEND}"
DEPEND="${CDEPEND}"

CONFIG_CHECK="~X86_MSR"

FILECAPS=(
	-M 755 cap_sys_rawio+ep usr/sbin/likwid-accessD
	--
	-M 755 cap_sys_rawio+ep usr/sbin/likwid-setFreq
)

PATCHES=(
	"${FILESDIR}/${PN}-4.3.1-fix-gnustack.patch"
)

pkg_setup() {
	fortran-2_pkg_setup
}

src_prepare() {
	# Ensure we build with a non executable stack
	sed \
		-e '/^SHARED_CFLAGS/s/$/ -Wa,--noexecstack/' \
		-i make/include_{GCC*,CLANG}.mk \
		|| die "Failed to set nonexecstack"

	# Make the install targets respect Q= for being quiet or not
	# MUCH easier for debugging
	sed -r \
		-e '/^install/,/^[a-z]/{/^\t@/{ s/@/$(Q)/; }}' \
		-i \
		Makefile || die "Failed to sed Makefile"

	sed -i \
		-e '/^\.NOTPARALLEL:/d' \
		Makefile \
		bench/Makefile \
		ext/hwloc/Makefile || die "Failed to re-enable parallel"

	default
}

export_emake_opts() {
	# Warning: this build system uses PREFIX in a way that differs from
	# autoconf! It's more like:
	# PREFIX=$(DESTDIR)$(INSTALLED_PREFIX)
	# it's not 100% like that, because parts of the Makefiles are inconsistent.
	# this is the same solution used in the upstream RPM specs
	# these variables are uppercase so they match what's put into Make.
	local INSTALLED_PREFIX=/usr
	local INSTALLED_LIBPREFIX=/usr/$(get_libdir) # upstream is '$(INSTALLED_PREFIX)/lib'
	local INSTALLED_MANPREFIX=/usr/share/man # upstream has it as used but undefined variable.
	# If the build is too loud, pass 'Q=@'
	src_compile_opts=(
		"Q="
		"INSTALLED_PREFIX=${INSTALLED_PREFIX}"
		"INSTALLED_LIBPREFIX=${INSTALLED_LIBPREFIX}"
		"INSTALLED_MANPREFIX=${INSTALLED_MANPREFIX}"
		"PREFIX=${INSTALLED_PREFIX}"
		"LIBPREFIX=${INSTALLED_LIBPREFIX}"
		"MANPREFIX=${INSTALLED_MANPREFIX}"
		"CC=$(tc-getCC)"
		"ANSI_CFLAGS=${CFLAGS}"
		"INSTRUMENT_BENCH=true"
		"FORTRAN_INTERFACE=$(usex fortran likwid.mod false)"
		"FC=$(usex fortran "${FC}" false)"
		"FCFLAGS=-J ./ -fsyntax-only" # needed for building correctly
	)
	src_install_opts=(
		"PREFIX=${D}${INSTALLED_PREFIX}"
		"LIBPREFIX=${D}${INSTALLED_LIBPREFIX}"
		"MANPREFIX=${D}${INSTALLED_MANPREFIX}"
	)
}

src_compile() {
	export_emake_opts
	emake \
		"${src_compile_opts[@]}" \
		|| die 'emake failed'
}

src_install () {
	export_emake_opts
	emake \
		"${src_compile_opts[@]}" \
		"${src_install_opts[@]}" \
		DESTDIR="${D}" \
		install || die 'emake install failed'

	use fortran && doheader likwid.mod

	# Fix Python filter added shortly after 4.3.3
	#python_fix_shebang "${D}"/usr/share/likwid/filter/

	# Do NOT use 'doman'! The upstream 'make install' target does a sed as it's
	# generating the final manpage to the real install dir; and the copies in
	# ${S} are unmodified.
	dodoc README.md CHANGELOG
	dodoc doc/*.txt
	dodoc doc/*.md
	dodoc -r doc/applications doc/archs
	# Fix upstream partial doc install
	rm -rf "${D}"/usr/share/likwid/docs || die
	ln -sf "/usr/share/doc/${PF}" "${D}"/usr/share/likwid/docs || die
}

pkg_preinst() {
	# This is now a symlink, but used to be a plain directory
	OLDDOCDIR=/usr/share/likwid/docs
	if [[ ! -L "${OLDDOCDIR}" && -d "${OLDDOCDIR}" ]]; then
		einfo "Cleaning up old docdir at ${OLDDOCDIR}"
		rm -rf "${OLDDOCDIR}" || die
	fi
}

pkg_postinst() {
	fcaps_pkg_postinst
	einfo "If you get 'Cannot gather values from MSR_PLATFORM_INFO', then 'modprobe msr'!"
	einfo
	ewarn "To enable users to access performance counters it is necessary to"
	ewarn "change the access permissions to /dev/cpu/msr[0]* devices."
	ewarn "It can be accomplished by adding the following line to file"
	ewarn "/etc/udev/rules.d/99-myrules.rules: KERNEL==\"msr[0-9]*\" MODE=\"0666\""
	ewarn "Alternatively, assign the MSR files to a unique group and use mode 0660"
}
