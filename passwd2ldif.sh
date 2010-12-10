#!/bin/bash

# Convert data from stdin in /etc/passwd syntax to LDIF.

while IFS=: read user uid gid cn homeDirectory loginShell
do
        cat <<-EOF
        dn: uid=${user},ou=people,o=yomiko
        objectClass: account
        objectClass: posixAccount
        uid: ${user}
        cn: ${cn:-not set}
        uidNumber: ${uid}
        gidNumber: ${gid}
        homeDirectory: ${homeDirectory}
        loginShell: ${loginShell}
        ${cn:-#} cn: description: ${cn}

        EOF
done
