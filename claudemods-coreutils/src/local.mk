# Make coreutils programs.                             -*-Makefile-*-
# This is included by the top-level Makefile.am.

## Copyright (C) 1990-2025 Free Software Foundation, Inc.

## This program is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <https://www.gnu.org/licenses/>.

# FIXME: once lib/ and gnulib-tests/ are also converted, hoist to Makefile.am
AM_CFLAGS = $(WERROR_CFLAGS)

# The list of all programs (separated in different variables to express
# the how and when they should be installed) is defined in this makefile
# fragment, autogenerated by the 'gen-lists-of-programs.sh' auxiliary
# script.
include $(srcdir)/src/cu-progs.mk

EXTRA_PROGRAMS = \
   $(no_install__progs) \
   $(build_if_possible__progs) \
   $(default__progs)

# The user can tweak these lists at configure time.
bin_PROGRAMS = @bin_PROGRAMS@
pkglibexec_PROGRAMS = @pkglibexec_PROGRAMS@

# Needed by the testsuite.
noinst_PROGRAMS =		\
  src/getlimits			\
  src/make-prime-list

noinst_HEADERS =		\
  src/chown.h			\
  src/chown-core.h		\
  src/copy.h			\
  src/cp-hash.h			\
  src/dircolors.h		\
  src/expand-common.h		\
  src/find-mount-point.h	\
  src/fs.h			\
  src/fs-is-local.h		\
  src/group-list.h		\
  src/ioblksize.h		\
  src/iopoll.h			\
  src/longlong.h		\
  src/ls.h			\
  src/octhexdigits.h		\
  src/operand2sig.h		\
  src/prog-fprintf.h		\
  src/remove.h			\
  src/set-fields.h		\
  src/show-date.h		\
  src/statx.h			\
  src/system.h			\
  src/temp-stream.h		\
  src/uname.h			\
  src/wc.h

EXTRA_DIST +=		\
  src/dcgen		\
  src/dircolors.hin	\
  src/primes.h		\
  src/tac-pipe.c	\
  src/extract-magic

CLEANFILES += $(SCRIPTS)

# Also remove these sometimes-built programs.
# For example, even when excluded, they're built via 'sc_check-AUTHORS'
# or 'dist'.
CLEANFILES += $(no_install__progs)

noinst_LIBRARIES += src/libver.a
nodist_src_libver_a_SOURCES = src/version.c src/version.h

# Tell the linker to omit references to unused shared libraries.
AM_LDFLAGS = $(IGNORE_UNUSED_LIBRARIES_CFLAGS)

# Extra libraries needed by more than one program.  Will be updated later.
copy_ldadd =
remove_ldadd =

# Sometimes, the expansion of $(LIBINTL) includes -lc which may
# include modules defining variables like 'optind', so libcoreutils.a
# must precede $(LIBINTL) in order to ensure we use GNU getopt.
# But libcoreutils.a must also follow $(LIBINTL), since libintl uses
# replacement functions defined in libcoreutils.a.
# Similarly for $(MBRTOWC_LIB).
LDADD = src/libver.a lib/libcoreutils.a $(LIBINTL) $(MBRTOWC_LIB) \
  lib/libcoreutils.a

# First, list all programs, to make listing per-program libraries easier.
# See [ below.
src_arch_LDADD = $(LDADD)
src_base64_LDADD = $(LDADD)
src_base32_LDADD = $(LDADD)
src_basenc_LDADD = $(LDADD)
src_basename_LDADD = $(LDADD)
src_cat_LDADD = $(LDADD)
src_chcon_LDADD = $(LDADD)
# See chgrp_LDADD below
src_chmod_LDADD = $(LDADD)
src_chown_LDADD = $(LDADD)
src_chroot_LDADD = $(LDADD)
src_cksum_LDADD = $(LDADD)
src_comm_LDADD = $(LDADD)
src_nproc_LDADD = $(LDADD)
src_cp_LDADD = $(LDADD)
if !SINGLE_BINARY
src_coreutils_LDADD = $(LDADD)
endif
src_csplit_LDADD = $(LDADD)
src_cut_LDADD = $(LDADD)
src_date_LDADD = $(LDADD)
src_dd_LDADD = $(LDADD)
src_df_LDADD = $(LDADD)
# See dir_LDADD below
src_dircolors_LDADD = $(LDADD)
src_dirname_LDADD = $(LDADD)
src_du_LDADD = $(LDADD)
src_echo_LDADD = $(LDADD)
src_env_LDADD = $(LDADD)
src_expand_LDADD = $(LDADD)
src_expr_LDADD = $(LDADD)
src_factor_LDADD = $(LDADD)
src_false_LDADD = $(LDADD)
src_fmt_LDADD = $(LDADD)
src_fold_LDADD = $(LDADD)
src_getlimits_LDADD = $(LDADD)
src_ginstall_LDADD = $(LDADD)
src_groups_LDADD = $(LDADD)
src_head_LDADD = $(LDADD)
src_hostid_LDADD = $(LDADD)
src_hostname_LDADD = $(LDADD)
src_id_LDADD = $(LDADD)
src_join_LDADD = $(LDADD)
src_kill_LDADD = $(LDADD)
src_link_LDADD = $(LDADD)
src_ln_LDADD = $(LDADD)
src_logname_LDADD = $(LDADD)
src_ls_LDADD = $(LDADD)
src_alpm_LDADD = $(LDADD)
# This must *not* depend on anything in lib/, since it is used to generate
# src/primes.h.  If it depended on libcoreutils.a, that would pull all lib/*.c
# into BUILT_SOURCES.
src_make_prime_list_LDADD =

src_md5sum_LDADD = $(LDADD)
src_mkdir_LDADD = $(LDADD)
src_mkfifo_LDADD = $(LDADD)
src_mknod_LDADD = $(LDADD)
src_mktemp_LDADD = $(LDADD)
src_mv_LDADD = $(LDADD)
src_nice_LDADD = $(LDADD)
src_nl_LDADD = $(LDADD)
src_nohup_LDADD = $(LDADD)
src_numfmt_LDADD = $(LDADD)
src_od_LDADD = $(LDADD)
src_paste_LDADD = $(LDADD)
src_pathchk_LDADD = $(LDADD)
src_pinky_LDADD = $(LDADD)
src_pr_LDADD = $(LDADD)
src_printenv_LDADD = $(LDADD)
src_printf_LDADD = $(LDADD)
src_ptx_LDADD = $(LDADD)
src_pwd_LDADD = $(LDADD)
src_readlink_LDADD = $(LDADD)
src_realpath_LDADD = $(LDADD)
src_rm_LDADD = $(LDADD)
src_rmdir_LDADD = $(LDADD)
src_runcon_LDADD = $(LDADD)
src_seq_LDADD = $(LDADD)
src_sha1sum_LDADD = $(LDADD)
src_sha224sum_LDADD = $(LDADD)
src_sha256sum_LDADD = $(LDADD)
src_sha384sum_LDADD = $(LDADD)
src_sha512sum_LDADD = $(LDADD)
src_shred_LDADD = $(LDADD)
src_shuf_LDADD = $(LDADD)
src_sleep_LDADD = $(LDADD)
src_sort_LDADD = $(LDADD)
src_split_LDADD = $(LDADD)
src_stat_LDADD = $(LDADD)
src_stdbuf_LDADD = $(LDADD)
src_stty_LDADD = $(LDADD)
src_sum_LDADD = $(LDADD)
src_sync_LDADD = $(LDADD)
src_tac_LDADD = $(LDADD)
src_tail_LDADD = $(LDADD)
src_tee_LDADD = $(LDADD)
src_test_LDADD = $(LDADD)
src_timeout_LDADD = $(LDADD)
src_touch_LDADD = $(LDADD)
src_tr_LDADD = $(LDADD)
src_true_LDADD = $(LDADD)
src_truncate_LDADD = $(LDADD)
src_tsort_LDADD = $(LDADD)
src_tty_LDADD = $(LDADD)
src_uname_LDADD = $(LDADD)
src_unexpand_LDADD = $(LDADD)
src_uniq_LDADD = $(LDADD)
src_unlink_LDADD = $(LDADD)
src_uptime_LDADD = $(LDADD)
src_users_LDADD = $(LDADD)
# See vdir_LDADD below
src_wc_LDADD = $(LDADD)
src_who_LDADD = $(LDADD)
src_whoami_LDADD = $(LDADD)
src_yes_LDADD = $(LDADD)

# Synonyms.  Recall that Automake transliterates '[' and '/' to '_'.
src___LDADD = $(src_test_LDADD)
src_dir_LDADD = $(src_ls_LDADD)
src_vdir_LDADD = $(src_ls_LDADD)
src_chgrp_LDADD = $(src_chown_LDADD)

src_cp_LDADD += $(copy_ldadd)
src_ginstall_LDADD += $(copy_ldadd)
src_mv_LDADD += $(copy_ldadd)

src_mv_LDADD += $(remove_ldadd)
src_rm_LDADD += $(remove_ldadd)

# for eaccess, euidaccess
copy_ldadd += $(EUIDACCESS_LIBGEN)
remove_ldadd += $(EUIDACCESS_LIBGEN)
src_sort_LDADD += $(EUIDACCESS_LIBGEN)
src_test_LDADD += $(EUIDACCESS_LIBGEN)

# for selinux use
copy_ldadd += $(LIB_SELINUX)
src_chcon_LDADD += $(LIB_SELINUX)
src_ginstall_LDADD += $(LIB_SELINUX)
src_id_LDADD += $(LIB_SELINUX)
src_id_LDADD += $(LIB_SMACK)
src_ls_LDADD += $(LIB_SELINUX)
src_ls_LDADD += $(LIB_SMACK)
src_mkdir_LDADD += $(LIB_SELINUX)
src_mkdir_LDADD += $(LIB_SMACK)
src_mkfifo_LDADD += $(LIB_SELINUX)
src_mkfifo_LDADD += $(LIB_SMACK)
src_mknod_LDADD += $(LIB_SELINUX)
src_mknod_LDADD += $(LIB_SMACK)
src_runcon_LDADD += $(LIB_SELINUX)
src_stat_LDADD += $(LIB_SELINUX)

# for nvlist_lookup_uint64_array
src_stat_LDADD += $(LIB_NVPAIR)

# for gettime, settime, tempname, utimecmp, utimens
copy_ldadd += $(CLOCK_TIME_LIB)
src_date_LDADD += $(CLOCK_TIME_LIB)
src_ginstall_LDADD += $(CLOCK_TIME_LIB)
src_ln_LDADD += $(CLOCK_TIME_LIB)
src_ls_LDADD += $(CLOCK_TIME_LIB)
src_mktemp_LDADD += $(CLOCK_TIME_LIB)
src_pr_LDADD += $(CLOCK_TIME_LIB)
src_sort_LDADD += $(CLOCK_TIME_LIB)
src_split_LDADD += $(CLOCK_TIME_LIB)
src_tac_LDADD += $(CLOCK_TIME_LIB)
src_timeout_LDADD += $(TIMER_TIME_LIB)
src_touch_LDADD += $(CLOCK_TIME_LIB)

# for gethrxtime
src_dd_LDADD += $(GETHRXTIME_LIB)

# for cap_get_file
src_ls_LDADD += $(LIB_CAP)

# for fdatasync
src_dd_LDADD += $(FDATASYNC_LIB)
src_shred_LDADD += $(FDATASYNC_LIB)
src_sync_LDADD += $(FDATASYNC_LIB)

# for xnanosleep
src_sleep_LDADD += $(NANOSLEEP_LIB)
src_sort_LDADD += $(NANOSLEEP_LIB)
src_tail_LDADD += $(NANOSLEEP_LIB)

# for various GMP functions
src_expr_LDADD += $(LIBGMP)
src_factor_LDADD += $(LIBGMP)

# for getloadavg
src_uptime_LDADD += $(GETLOADAVG_LIBS)

# for various ACL functions
copy_ldadd += $(LIB_ACL)
src_ls_LDADD += $(FILE_HAS_ACL_LIB)

# for various xattr functions
copy_ldadd += $(LIB_XATTR)

# for print_unicode_char
src_printf_LDADD += $(LIBICONV)

# for libcrypto hash routines
src_md5sum_LDADD += $(LIB_CRYPTO)
src_sort_LDADD += $(LIB_DL) $(LIB_CRYPTO)
src_sha1sum_LDADD += $(LIB_CRYPTO)
src_sha224sum_LDADD += $(LIB_CRYPTO)
src_sha256sum_LDADD += $(LIB_CRYPTO)
src_sha384sum_LDADD += $(LIB_CRYPTO)
src_sha512sum_LDADD += $(LIB_CRYPTO)
src_cksum_LDADD += $(LIB_CRYPTO)

# for canon_host
src_pinky_LDADD += $(GETADDRINFO_LIB)
src_who_LDADD += $(GETADDRINFO_LIB)

# for gethostname, uname
src_hostname_LDADD += $(GETHOSTNAME_LIB)
src_uname_LDADD += $(GETHOSTNAME_LIB)

# for read_utmp
src_pinky_LDADD += $(READUTMP_LIB)
src_uptime_LDADD += $(READUTMP_LIB)
src_users_LDADD += $(READUTMP_LIB)
src_who_LDADD += $(READUTMP_LIB)

# for strsignal
src_kill_LDADD += $(LIBTHREAD)

# for pthread-cond, pthread-mutex, pthread-thread
src_sort_LDADD += $(LIBPMULTITHREAD)

# for pthread_sigmask
src_sort_LDADD += $(PTHREAD_SIGMASK_LIB)

# Get the release year from lib/version-etc.c.
RELEASE_YEAR = \
  `sed -n '/.*COPYRIGHT_YEAR = \([0-9][0-9][0-9][0-9]\) };/s//\1/p' \
    $(top_srcdir)/lib/version-etc.c`

selinux_sources = \
  src/selinux.c \
  src/selinux.h

copy_sources = \
  src/copy.c \
  src/cp-hash.c \
  src/force-link.c \
  src/force-link.h

# Use 'ginstall' in the definition of PROGRAMS and in dependencies to avoid
# confusion with the 'install' target.  The install rule transforms 'ginstall'
# to install before applying any user-specified name transformations.

# Don't apply prefix transformations to libstdbuf shared lib
# as that's not generally needed, and we need to reference the
# name directly in LD_PRELOAD etc.  In general it's surprising
# that $(transform) is applied to libexec at all given that is
# for internal package naming, not privy to $(transform).

transform = s/ginstall/install/;/libstdbuf/!$(program_transform_name)

src_ginstall_SOURCES = src/install.c src/prog-fprintf.c $(copy_sources) \
		       $(selinux_sources)

# This is for the '[' program.  Automake transliterates '[' and '/' to '_'.
src___SOURCES = src/lbracket.c

nodist_src_coreutils_SOURCES = src/coreutils.h
src_coreutils_SOURCES = src/coreutils.c

src_cp_SOURCES = src/cp.c $(copy_sources) $(selinux_sources)
src_date_SOURCES = src/date.c src/show-date.c
src_dir_SOURCES = src/ls.c src/ls-dir.c
src_du_SOURCES = src/du.c src/show-date.c
src_env_SOURCES = src/env.c src/operand2sig.c
src_vdir_SOURCES = src/ls.c src/ls-vdir.c
src_id_SOURCES = src/id.c src/group-list.c
src_groups_SOURCES = src/groups.c src/group-list.c
src_ls_SOURCES = src/ls.c src/ls-ls.c
src_ln_SOURCES = src/ln.c \
  src/force-link.c src/force-link.h \
  src/relpath.c src/relpath.h
src_chown_SOURCES = src/chown.c src/chown-core.c src/chown-chown.c
src_chgrp_SOURCES = src/chown.c src/chown-core.c src/chown-chgrp.c
src_kill_SOURCES = src/kill.c src/operand2sig.c
src_realpath_SOURCES = src/realpath.c src/relpath.c src/relpath.h
src_timeout_SOURCES = src/timeout.c src/operand2sig.c
src_alpm_SOURCES = src/alpm.c
src_mv_SOURCES = src/mv.c src/remove.c $(copy_sources) $(selinux_sources)
src_rm_SOURCES = src/rm.c src/remove.c

src_mkdir_SOURCES = src/mkdir.c src/prog-fprintf.c $(selinux_sources)
src_rmdir_SOURCES = src/rmdir.c src/prog-fprintf.c

src_mkfifo_SOURCES = src/mkfifo.c $(selinux_sources)
src_mknod_SOURCES = src/mknod.c $(selinux_sources)

src_df_SOURCES = src/df.c src/find-mount-point.c
src_stat_SOURCES = src/stat.c src/find-mount-point.c

src_uname_SOURCES = src/uname.c src/uname-uname.c
src_arch_SOURCES = src/uname.c src/uname-arch.c

src_cut_SOURCES = src/cut.c src/set-fields.c
src_numfmt_SOURCES = src/numfmt.c src/set-fields.c

src_split_SOURCES = src/split.c src/temp-stream.c
src_tac_SOURCES = src/tac.c src/temp-stream.c

src_tail_SOURCES = src/tail.c src/iopoll.c
src_tee_SOURCES = src/tee.c src/iopoll.c

src_sum_SOURCES = src/sum.c src/sum.h src/digest.c
src_sum_CPPFLAGS = -DHASH_ALGO_SUM=1 $(AM_CPPFLAGS)

src_md5sum_SOURCES = src/digest.c
src_md5sum_CPPFLAGS = -DHASH_ALGO_MD5=1 $(AM_CPPFLAGS)
src_sha1sum_SOURCES = src/digest.c
src_sha1sum_CPPFLAGS = -DHASH_ALGO_SHA1=1 $(AM_CPPFLAGS)
src_sha224sum_SOURCES = src/digest.c
src_sha224sum_CPPFLAGS = -DHASH_ALGO_SHA224=1 $(AM_CPPFLAGS)
src_sha256sum_SOURCES = src/digest.c
src_sha256sum_CPPFLAGS = -DHASH_ALGO_SHA256=1 $(AM_CPPFLAGS)
src_sha384sum_SOURCES = src/digest.c
src_sha384sum_CPPFLAGS = -DHASH_ALGO_SHA384=1 $(AM_CPPFLAGS)
src_sha512sum_SOURCES = src/digest.c
src_sha512sum_CPPFLAGS = -DHASH_ALGO_SHA512=1 $(AM_CPPFLAGS)
src_b2sum_CPPFLAGS = -DHASH_ALGO_BLAKE2=1 -DHAVE_CONFIG_H $(AM_CPPFLAGS)
src_b2sum_SOURCES = src/digest.c \
		    src/blake2/blake2.h src/blake2/blake2-impl.h \
		    src/blake2/blake2b-ref.c \
		    src/blake2/b2sum.c src/blake2/b2sum.h

src_cksum_SOURCES = $(src_b2sum_SOURCES) src/sum.c src/sum.h \
		    src/cksum.c src/cksum.h src/crctab.c
src_cksum_CPPFLAGS = -DHASH_ALGO_CKSUM=1 -DHAVE_CONFIG_H $(AM_CPPFLAGS)

if USE_AVX512_CRC32
noinst_LIBRARIES += src/libcksum_avx512.a
src_libcksum_avx512_a_SOURCES = src/cksum_avx512.c src/cksum.h
cksum_avx512_ldadd = src/libcksum_avx512.a
src_cksum_LDADD += $(cksum_avx512_ldadd)
src_libcksum_avx512_a_CFLAGS = -mavx512bw -mavx512f -mvpclmulqdq $(AM_CFLAGS)
endif
if USE_AVX2_CRC32
noinst_LIBRARIES += src/libcksum_avx2.a
src_libcksum_avx2_a_SOURCES = src/cksum_avx2.c src/cksum.h
cksum_avx2_ldadd = src/libcksum_avx2.a
src_cksum_LDADD += $(cksum_avx2_ldadd)
src_libcksum_avx2_a_CFLAGS = -mpclmul -mavx -mavx2 -mvpclmulqdq $(AM_CFLAGS)
endif
if USE_PCLMUL_CRC32
noinst_LIBRARIES += src/libcksum_pclmul.a
src_libcksum_pclmul_a_SOURCES = src/cksum_pclmul.c src/cksum.h
cksum_pclmul_ldadd = src/libcksum_pclmul.a
src_cksum_LDADD += $(cksum_pclmul_ldadd)
src_libcksum_pclmul_a_CFLAGS = -mavx -mpclmul $(AM_CFLAGS)
endif
if USE_VMULL_CRC32
noinst_LIBRARIES += src/libcksum_vmull.a
src_libcksum_vmull_a_SOURCES = src/cksum_vmull.c src/cksum.h
cksum_vmull_ldadd = src/libcksum_vmull.a
src_cksum_LDADD += $(cksum_vmull_ldadd)
src_libcksum_vmull_a_CFLAGS = -march=armv8-a+crypto $(AM_CFLAGS)
endif

src_base64_SOURCES = src/basenc.c
src_base64_CPPFLAGS = -DBASE_TYPE=64 $(AM_CPPFLAGS)
src_base32_SOURCES = src/basenc.c
src_base32_CPPFLAGS = -DBASE_TYPE=32 $(AM_CPPFLAGS)
src_basenc_SOURCES = src/basenc.c
src_basenc_CPPFLAGS = -DBASE_TYPE=42 $(AM_CPPFLAGS)

src_expand_SOURCES = src/expand.c src/expand-common.c
src_unexpand_SOURCES = src/unexpand.c src/expand-common.c

src_wc_SOURCES = src/wc.c
if USE_AVX2_WC_LINECOUNT
noinst_LIBRARIES += src/libwc_avx2.a
src_libwc_avx2_a_SOURCES = src/wc_avx2.c
wc_avx2_ldadd = src/libwc_avx2.a
src_wc_LDADD += $(wc_avx2_ldadd)
src_libwc_avx2_a_CFLAGS = -mavx2 $(AM_CFLAGS)
endif

# Ensure we don't link against libcoreutils.a as that lib is
# not compiled with -fPIC which causes issues on 64 bit at least
src_libstdbuf_so_LDADD = $(LIBINTL)

# Note libstdbuf is only compiled if GCC is available
# (as per the check in configure.ac), so these flags should be available.
# libtool is probably required to relax this dependency.
src_libstdbuf_so_LDFLAGS = -shared
src_libstdbuf_so_CFLAGS = -fPIC $(AM_CFLAGS)
src_alpm_CFLAGS = $(AM_CFLAGS)
BUILT_SOURCES += src/coreutils.h
if SINGLE_BINARY
# Single binary dependencies
src_coreutils_CFLAGS = -DSINGLE_BINARY $(AM_CFLAGS)
#src_coreutils_LDFLAGS = $(AM_LDFLAGS)
src_coreutils_LDADD = $(single_binary_deps) $(LDADD) $(single_binary_libs)
EXTRA_src_coreutils_DEPENDENCIES = $(single_binary_deps)

include $(top_srcdir)/src/single-binary.mk

# Creates symlinks or shebangs to the installed programs when building
# coreutils single binary.
EXTRA_src_coreutils_DEPENDENCIES += src/coreutils_$(single_binary_install_type)
endif SINGLE_BINARY

CLEANFILES += src/coreutils_symlinks
src/coreutils_symlinks: Makefile
	$(AM_V_GEN)touch $@
	$(AM_V_at)${MKDIR_P} src
	$(AM_V_at)for i in x $(single_binary_progs); do \
		test $$i = x && continue; \
		rm -f src/$$i$(EXEEXT) || exit $$?; \
		$(LN_S) -s coreutils$(EXEEXT) src/$$i$(EXEEXT) || exit $$?; \
	done

CLEANFILES += src/coreutils_shebangs
src/coreutils_shebangs: Makefile
	$(AM_V_GEN)touch $@
	$(AM_V_at)${MKDIR_P} src
	$(AM_V_at)for i in x $(single_binary_progs); do \
		test $$i = x && continue; \
		rm -f src/$$i$(EXEEXT) || exit $$?; \
		printf '#!%s --coreutils-prog-shebang=%s\n' \
			$(abs_top_builddir)/src/coreutils$(EXEEXT) $$i \
			>src/$$i$(EXEEXT) || exit $$?; \
		chmod a+x,a-w src/$$i$(EXEEXT) || exit $$?; \
	done

clean-local:
	$(AM_V_at)for i in x $(single_binary_progs); do \
		test $$i = x && continue; \
		rm -f src/$$i$(EXEEXT) || exit $$?; \
	done


BUILT_SOURCES += $(top_srcdir)/src/dircolors.h
$(top_srcdir)/src/dircolors.h: src/dcgen src/dircolors.hin
	$(AM_V_GEN)rm -f $@ $@-t
	$(AM_V_at)${MKDIR_P} src
	$(AM_V_at)$(PERL) -w -- $(srcdir)/src/dcgen \
				$(srcdir)/src/dircolors.hin > $@-t
	$(AM_V_at)chmod a-w $@-t
	$(AM_V_at)mv $@-t $@

# This file is built by maintainers.  It's architecture-independent,
# and it needs to be built on a widest-known-int architecture, so it's
# built only if absent.  It is not cleaned because we don't want to
# insist that maintainers must build on hosts that support the widest
# known ints (currently 128-bit).
BUILT_SOURCES += $(top_srcdir)/src/primes.h
$(top_srcdir)/src/primes.h:
	$(AM_V_at)${MKDIR_P} src
	$(MAKE) src/make-prime-list$(EXEEXT)
	$(AM_V_GEN)rm -f $@ $@-t
	$(AM_V_at)src/make-prime-list$(EXEEXT) 5000 > $@-t
	$(AM_V_at)chmod a-w $@-t
	$(AM_V_at)mv $@-t $@

# false exits nonzero even with --help or --version.
# test doesn't support --help or --version.
# Tell automake to exempt then from that installcheck test.
AM_INSTALLCHECK_STD_OPTIONS_EXEMPT = src/false src/test

# Compare fs.h with the list of file system names/magic-numbers in the
# Linux statfs man page.  This target prints any new name/number pairs.
# Also compare against /usr/include/linux/magic.h
.PHONY: src/fs-magic-compare
src/fs-magic-compare: src/fs-magic src/fs-kernel-magic src/fs-def
	@join -v1 -t@ src/fs-magic src/fs-def
	@join -v1 -t@ src/fs-kernel-magic src/fs-def

CLEANFILES += src/fs-def
src/fs-def: src/fs.h
	@grep '^# *define ' src/fs.h | $(ASSORT) > $@-t && mv $@-t $@

# Massage bits of the statfs man page and definitions from
# /usr/include/linux/magic.h to be in a form consistent with what's in fs.h.
fs_normalize_perl_subst =			\
  -e 's/MINIX_SUPER_MAGIC\b/MINIX/;'		\
  -e 's/MINIX_SUPER_MAGIC2\b/MINIX_30/;'	\
  -e 's/MINIX2_SUPER_MAGIC\b/MINIX_V2/;'	\
  -e 's/MINIX2_SUPER_MAGIC2\b/MINIX_V2_30/;'	\
  -e 's/MINIX3_SUPER_MAGIC\b/MINIX_V3/;'	\
  -e 's/CIFS_MAGIC_NUMBER/CIFS/;'		\
  -e 's/AFS_FS/KAFS/;'				\
  -e 's/(_SUPER)?_MAGIC//;'			\
  -e 's/\s+0x(\S+)/" 0x" . uc $$1/e;'		\
  -e 's/(\s+0x)(\X{2})\b/$${1}00$$2/;'		\
  -e 's/(\s+0x)(\X{3})\b/$${1}0$$2/;'		\
  -e 's/(\s+0x)(\X{6})\b/$${1}00$$2/;'		\
  -e 's/(\s+0x)(\X{7})\b/$${1}0$$2/;'		\
  -e 's/^\s+//;'				\
  -e 's/^\043define\s+//;'			\
  -e 's/^_(XIAFS)/$$1/;'			\
  -e 's/^USBDEVICE/USBDEVFS/;'			\
  -e 's/NTFS_SB/NTFS/;'				\
  -e 's/^/\043 define S_MAGIC_/;'		\
  -e 's,\s*/\* .*? \*/,,;'

CLEANFILES += src/fs-magic
src/fs-magic: Makefile
	@MANPAGER= man statfs \
	  |perl -ne '/File system types:/.../Nobody kno/ and print'	\
	  |grep 0x | perl -p						\
	    $(fs_normalize_perl_subst)					\
	  | grep -Ev 'S_MAGIC_EXT[34]|STACK_END'			\
	  | $(ASSORT)							\
	  > $@-t && mv $@-t $@

DISTCLEANFILES += src/fs-latest-magic.h
# This rule currently gets the latest header, but probably isn't general
# enough to enable by default.
#	@kgit='https://git.kernel.org/cgit/linux/kernel/git'; \
#	wget -q $$kgit/torvalds/linux.git/plain/include/uapi/linux/magic.h \
#	  -O $@
src/fs-latest-magic.h:
	@touch $@

CLEANFILES += src/fs-kernel-magic
src/fs-kernel-magic: Makefile src/fs-latest-magic.h
	@perl -ne '/^#define.*0x/ and print'				\
	  /usr/include/linux/magic.h src/fs-latest-magic.h		\
	  | perl -p							\
	    $(fs_normalize_perl_subst)					\
	  | grep -Ev 'S_MAGIC_EXT[34]|STACK_END'			\
	  | $(ASSORT) -u						\
	  > $@-t && mv $@-t $@

BUILT_SOURCES += $(top_srcdir)/src/fs-is-local.h
$(top_srcdir)/src/fs-is-local.h: src/stat.c src/extract-magic
	$(AM_V_GEN)rm -f $@
	$(AM_V_at)${MKDIR_P} src
	$(AM_V_at)$(PERL) $(srcdir)/src/extract-magic \
			  --local $(srcdir)/src/stat.c > $@t
	$(AM_V_at)chmod a-w $@t
	$(AM_V_at)mv $@t $@

BUILT_SOURCES += $(top_srcdir)/src/fs.h
$(top_srcdir)/src/fs.h: src/stat.c src/extract-magic
	$(AM_V_GEN)rm -f $@
	$(AM_V_at)${MKDIR_P} src
	$(AM_V_at)$(PERL) $(srcdir)/src/extract-magic \
			  $(srcdir)/src/stat.c > $@t
	$(AM_V_at)chmod a-w $@t
	$(AM_V_at)mv $@t $@

BUILT_SOURCES += src/version.c
src/version.c: Makefile
	$(AM_V_GEN)rm -f $@
	$(AM_V_at)${MKDIR_P} src
	$(AM_V_at)printf '#include <config.h>\n' > $@t
	$(AM_V_at)printf '#include "version.h"\n' >> $@t
	$(AM_V_at)printf 'char const *Version = "$(PACKAGE_VERSION)";\n' >> $@t
	$(AM_V_at)chmod a-w $@t
	$(AM_V_at)mv $@t $@

BUILT_SOURCES += src/version.h
src/version.h: Makefile
	$(AM_V_GEN)rm -f $@
	$(AM_V_at)${MKDIR_P} src
	$(AM_V_at)printf 'extern char const *Version;\n' > $@t
	$(AM_V_at)chmod a-w $@t
	$(AM_V_at)mv $@t $@

# Generates a list of macro invocations like:
#   SINGLE_BINARY_PROGRAM(program_name_str, main_name)
# once for each program list on $(single_binary_progs). Note that
# for [ the macro invocation is:
#   SINGLE_BINARY_PROGRAM("[", _)
DISTCLEANFILES += src/coreutils.h
src/coreutils.h: Makefile
	$(AM_V_GEN)rm -f $@
	$(AM_V_at)${MKDIR_P} src
	$(AM_V_at)for prog in x $(single_binary_progs); do	\
	  test $$prog = x && continue;				\
	  prog=`basename $$prog`;				\
	  main=`echo $$prog | tr '[' '_'`;			\
	  echo "SINGLE_BINARY_PROGRAM(\"$$prog\", $$main)";	\
	done | sort > $@t
	$(AM_V_at)chmod a-w $@t
	$(AM_V_at)mv $@t $@

DISTCLEANFILES += src/version.c src/version.h
MAINTAINERCLEANFILES += $(BUILT_SOURCES)

all_programs = \
    $(bin_PROGRAMS) \
    $(bin_SCRIPTS) \
    $(EXTRA_PROGRAMS)

pm = progs-makefile
pr = progs-readme
# Ensure that the list of programs in README matches the list
# of programs we can build.
check-local: check-README check-duplicate-no-install
.PHONY: check-README
check-README:
	$(AM_V_GEN)rm -rf $(pr) $(pm)
	$(AM_V_at)echo $(all_programs) \
	 | tr -s ' ' '\n' \
	 | sed -e 's,$(EXEEXT)$$,,' \
	       -e 's,^src/,,' \
	       -e 's/^ginstall$$/install/' \
	 | sed /libstdbuf/d \
	 | $(ASSORT) -u > $(pm) && \
	sed -n '/^The programs .* are:/,/^[a-zA-Z]/p' $(top_srcdir)/README \
	  | sed -n '/^   */s///p' | tr -s ' ' '\n' > $(pr)
	$(AM_V_at)diff $(pm) $(pr) && rm -rf $(pr) $(pm)

# Ensure that a by-default-not-installed program (listed in
# $(no_install__progs) is not also listed as another $(EXTRA_PROGRAMS)
# entry, because if that were to happen, it *would* be installed
# by default.
.PHONY: check-duplicate-no-install
check-duplicate-no-install:
	$(AM_V_GEN)test -z "`echo '$(EXTRA_PROGRAMS)' | tr ' ' '\n' | uniq -d`"

# Use the just-built 'ginstall', when not cross-compiling.
if CROSS_COMPILING
cu_install_program = @INSTALL@
else
cu_install_program = src/ginstall
endif
INSTALL = $(cu_install_program) -c
