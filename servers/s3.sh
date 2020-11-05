#!/bin/bash
rm lista.txt
input="wservers.txt"
while read -r fqdn alias
do
	address=$(dig +short $fqdn | grep 148)
	if [ -z "$address" ]; then 
		echo "*** $fqdn - $alias  no ip"
		continue
	fi
	echo "ip=$address fqdn=$fqdn descrip=$alias" >> lista.txt
	configfile=$(echo "$fqdn" | sed 's/umich.mx/cfg/')
	host_name=$(echo "$fqdn" | sed 's/.umich.mx//')
	echo "
define host {
        use                     generic-web-server
        host_name		$host_name
        alias			$alias
        address			$address
        parents                 umich_mx
}" > cfg/$configfile

done < "$input"

