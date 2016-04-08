#!/bin/bash

GREEN='\033[1;32m'
RED='\033[1;31m'
NC='\033[0m' # No Color

print_variation() {

	#curl -X GET "https://www.invertironline.com/titulo/cotizacion/BCBA/$1" -s | grep "data-field=\"Variacion\"" | sed s/\(\<span\ data-field=\"Variacion\"\>//g | sed s!\</span\>\%\)!!g | xargs;

	URL="https://www.invertironline.com/titulo/cotizacion/BCBA/$1";

	VARIATION="$(curl -X GET $URL -s | grep data-field=\"Variacion\" | sed s!\</span\>%\)!!g | sed s!\(\<span\>!!g | sed s!\(\<span\ data-field=\"Variacion\"\>!!g | xargs)";

	SIGN=${VARIATION:0:1}

	if [ "$SIGN" == "-" ]; then
		printf "$1 --> ${RED}${VARIATION}%%${NC}\n";
	else
		printf "$1 --> ${GREEN}${VARIATION}%%${NC}\n";
	fi;

}

for var in "$@"
do
    print_variation "$var"
done
