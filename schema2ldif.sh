#!/bin/bash

# Convert an OpenLDAP .schema file to LDIF

# Copyright (c) 2012 Peter Dinges <pdinges@acm.org>
#
# See LICENSE for licensing terms.

if [ -z "$1" ]; then
	echo "Convert an OpenLDAP schema file to LDIF and print it to stdout."
	echo
	echo "Usage: $0 FILE"
	echo "where FILE is the name of an OpenLDAP schema file."
	echo "The file extension must be .schema to get valid output."
	echo
	exit 1
fi

schemaFile=$1
schemaName=$( basename ${schemaFile} | sed 's/\.schema$//' )

if [[ -f ${schemaFile} && ! -f ${targetFile} ]]; then
	echo dn: cn=${schemaName},cn=schema,cn=config
	echo objectClass: olcSchemaConfig
	echo cn: ${schemaName}

	cat ${schemaFile} | \
		egrep -v '^\s*#' | \
		awk '
			BEGIN { i=0; }
			{
				# Move all text belonging to one entry into
				# one line by counting parentheses.
				# i==0 means an equal number of opening and
				# closing ones, so a new entry begins.
				printf("%s", $0);
				i = i + split($0, a, "(") - split($0, a, ")");
				if (i == 0) printf("\n");
			}
		' | \
		sed -e 's/\s\+/ /g' \
			-e 's/attributetype/olcAttributeTypes:/' \
			-e 's/objectclass/olcObjectClasses:/' | \
		egrep -v '^$'
fi
