#!/bin/sh

if [ -z "$1" ]; then
	echo "Only print entries of an LDIF file that contain a certain pattern."
	echo
	echo "Usage: $0 REGEX < LDIF_FILE"
	echo "where REGEX is an AWK regular expression that describes the"
	echo "pattern which must occur in an entry."
	echo
	exit 1
fi

awk "
BEGIN { buf=\"\"; found=0; }
# Save line in buffer (pattern might occur later).
{ buf=sprintf(\"%s\n%s\", buf, \$0); }
# Look for pattern in entry.
/$1/{ found=1; }
# End of entry; print it if a line matched. Reset.
/^\$/{ if ( found ) print buf; buf=\"\"; found=0; }"
