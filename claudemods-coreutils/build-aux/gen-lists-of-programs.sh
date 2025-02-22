set -x
#!/bin/sh
# Generate lists of all coreutils programs, to be fed both to Autoconf
# and Automake, and with further distinctions about how and when these
# programs should be built.  This is useful to avoid duplicating these
# list definitions among several files ('configure.ac' and
# 'src/local.mk' at least); such duplication had proved a source of
# inconsistencies and bugs in the past.

set -u
set -e

# These are the names of programs that are neither built nor installed
# by default.  This list is *not* intended for programs like 'who',
# 'nice', 'chroot', etc., that are built only when certain requisite
# system features are detected.
# If you would like to install programs from this list anyway, say A and B,
# use "--enable-install-program=A,B" when invoking configure.
disabled_by_default_progs='
    arch
    coreutils
    hostname
'

# Programs that can be built only when certain requisite system
# features are detected at configure time.
build_if_possible_progs='
    chroot
    df
    hostid
    libstdbuf.so
    nice
    pinky
    stdbuf
    stty
    timeout
    users
    who
'

# All the other programs, to be built by default, and that should
# be buildable without problems on any target system.
normal_progs='
    [
    alpm
    b2sum
    base64
    base32
    basenc
    basename
    cat
    chcon
    chgrp
    chmod
    chown
    cksum
    comm
    cp
    csplit
    cut
    date
    dd
    dir
    dircolors
    dirname
    du
    echo
    env
    expand
    expr
    factor
    false
    fmt
    fold
    ginstall
    groups
    head
    id
    join
    kill
    link
    ln
    logname
    ls
    md5sum
    mkdir
    mkfifo
    mknod
    mktemp
    mv
    nl
    nproc
    nohup
    numfmt
    od
    paste
    pathchk
    pr
    printenv
    printf
    ptx
    pwd
    readlink
    realpath
    rm
    rmdir
    runcon
    seq
    sha1sum
    sha224sum
    sha256sum
    sha384sum
    sha512sum
    shred
    shuf
    sleep
    sort
    split
    stat
    sum
    sync
    tac
    tail
    tee
    test
    touch
    tr
    true
    truncate
    tsort
    tty
    uname
    unexpand
    uniq
    unlink
    uptime
    vdir
    wc
    whoami
    yes
'

me=`echo "$0" | sed 's,.*/,,'`
msg="Automatically generated by $me.  DO NOT EDIT BY HAND!"

case $#,$1 in
  1,--autoconf|1,--for-autoconf)
    echo "dnl $msg"
    for p in $normal_progs; do
      test x"$p" = x"[" && p='@<:@'
      echo "gl_ADD_PROG([optional_bin_progs], [$p])"
    done
    # Extra 'echo' to normalize whitespace.
    echo "no_install_progs_default='`echo $disabled_by_default_progs`'"
    sed 's/^ *//' <<END
        # Given the name of a variable containing a space-separated
        # list of install-by-default programs and the actual list of
        # do-not-install-by-default programs, modify the former variable
        # to reflect any "do-install" and "don't-install" requests.
        # That is, add any program specified via --enable-install-program,
        # and remove any program specified via --enable-no-install-program.
        # Note how the second argument below is a literal, with ","
        # separators.  That is required due to the way the macro works,
        # and since the corresponding ./configure option argument is
        # comma-separated on input.
        gl_INCLUDE_EXCLUDE_PROG([optional_bin_progs], [`\
          echo $disabled_by_default_progs \
                                    | sed 's/ /,/g'`])
END
    ;;
  1,--automake|1,--for-automake)
    echo "## $msg"
    progsdir=src
    echo no_install__progs =
    for p in $disabled_by_default_progs; do
      echo no_install__progs += $progsdir/$p
    done
    echo build_if_possible__progs =
    for p in $build_if_possible_progs; do
      echo build_if_possible__progs += $progsdir/$p
    done
    echo default__progs =
    for p in $normal_progs; do
      echo default__progs += $progsdir/$p
    done
    ;;
  1,--list-progs)
    for p in $disabled_by_default_progs $build_if_possible_progs \
        $normal_progs; do
      echo $p
    done
    ;;
  *)
    echo "$0: invalid usage" >&2; exit 2
    ;;
esac

exit 0
