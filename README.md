LDAP Data Interchange Format (LDIF) Tools
=========================================

Little helpers for handling [LDIF][ldif] files.

Users of these scripts should be somewhat knowledgable regarding LDAP
and Linux, so I won't add too many explanations.  I originally wrote
the scripts while setting up [OpenLDAP][openldap] with the
[dynamic LDAP configuration][openldap-dynamic-config]
engine for serving parts of the Linux `passwd` database (via
[NSS][libnss-ldap]).  I put them here in the hope that they might be
useful to someone.


`ldiffilter.sh`
---------------

This script reads LDIF entries and prints only those entries that
contain a match of the given regular expression.  It reads the entries
from its standard input; its first command line argument is the (awk)
regular expression.

In contrast to `grep`, `ldiffilter.sh` will print the *whole* entry if
it contains a matching substring.  Since `grep` is line based, it is
tricky to specify the right number of lines to print before and after
matches.  You can think of this script as a *LDIF object based*
variant of `grep`.

**Note:** The script expects the LDIF file to end with an empty line.
  (Empty lines signal the end of an entry.)

Printing all entries in `foo.ldif` that contain the pattern `B.z+`
(which only occurs in the `cn` attribute of the second entry):
~~~
$ cat foo.ldif 
dn: uid=bar,o=foo
objectClass: fooObject
uid: bar
cn: Bar

dn: uid=bazzz,o=foo
objectClass: fooObject
uid: bazzz
cn: Bazzz

$ cat foo.ldif | ./ldiffilter.sh B.z+

dn: uid=bazzz,o=foo
objectClass: fooObject
uid: bazzz
cn: Bazzz

~~~


`passwd2ldif.sh` 
----------------

This script converts the entries of a flat Linux `passwd` database
(typically `/etc/passwd`) into `posixAccount` objects.  Use `ldapadd`
to insert the objects into the database.

**Note:**
* Passwords will be ignored.  They have to be added with `ldappasswd`.
* By default, the path of the objects is `ou=people,o=mydomain`.  Make
  sure to adapt the path to your needs.

~~~~
$ cat /etc/passwd | ./passwd2ldif.sh
 
dn: uid=root,ou=people,o=mydomain
objectClass: account
objectClass: posixAccount
uid: root
cn: root
uidNumber: 0
gidNumber: 0
homeDirectory: /root
loginShell: /bin/bash
root cn: description: root

[...]
~~~~


`schema2ldif.sh`
----------------

This script converts an
[OpenLDAP schema](http://www.openldap.org/doc/admin24/schema.html)
file into the corresponding internal LDIF format.  The LDIF can then
be used with the [dynamic LDAP configuration][openldap-dynamic-config]
engine.

The schema file should have a `.schema` extension.  Otherwise, the
schema name `cn=${schemaName}` may be set to the wrong value.

~~~~
$ schema2ldif.sh cosine.schema
~~~~


Copyright
---------

Copyright (c) 2012 Peter Dinges.  The LDIF tools are available under
the open-source [MIT License][mit-license].

[ldif]: http://en.wikipedia.org/wiki/LDIF "LDAP Data Interchange Format"
[openldap]: http://openldap.org "OpenLDAP LDAP Server"
[openldap-dynamic-config]: http://www.openldap.org/doc/admin24/slapdconf2.html
[libnss-ldap]: http://wiki.debian.org/LDAP/NSS "Using an LDAP server for serving Linux information databases"
[mit-license]: http://opensource.org/licenses/mit-license.php
