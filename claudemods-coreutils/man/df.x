'\" Copyright (C) 1998-2025 Free Software Foundation, Inc.
'\"
'\" This is free software.  You may redistribute copies of it under the terms
'\" of the GNU General Public License <https://www.gnu.org/licenses/gpl.html>.
'\" There is NO WARRANTY, to the extent permitted by law.
[NAME]
df \- report file system space usage
[DESCRIPTION]
This manual page
documents the GNU version of
.BR df .
.B df
displays the amount of space available on the file system
containing each file name argument.  If no file name is given, the
space available on all currently mounted file systems is shown.
Space is shown in 1K blocks by default, unless the environment
variable POSIXLY_CORRECT is set, in which case 512-byte blocks are
used.
.PP
If an argument is the absolute file name of a device node containing a
mounted file system,
.B df
shows the space available on that file system rather than on the
file system containing the device node.  This version of
.B df
cannot show the space available on unmounted file systems, because on
most kinds of systems doing so requires non-portable intimate
knowledge of file system structures.
.SH OPTIONS
