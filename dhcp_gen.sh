#!/bin/bash
function hostdef {
        echo host $1 {
        echo -e \\thardware ethernet $2\;
        echo -e \\tfixed-address $3\;
        echo -e \\toption host-name \"$1\"\;
        echo }
        echo
}

cat $1 | while read name mac ip; do hostdef $name $mac $ip; done
