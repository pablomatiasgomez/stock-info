#!/bin/bash

GREEN='\033[1;32m'
RED='\033[1;31m'
NC='\033[0m' # No Color

get_variation_from_io() {
	#curl -X GET "https://www.invertironline.com/titulo/cotizacion/BCBA/$1" -s | grep "data-field=\"Variacion\"" | sed s/\(\<span\ data-field=\"Variacion\"\>//g | sed s!\</span\>\%\)!!g | xargs;

	URL="https://www.invertironline.com/titulo/cotizacion/BCBA/$1";

	VARIATION="$(curl -X GET $URL -s | grep data-field=\"Variacion\" | sed s!\</span\>%\)!!g | sed s!\(\<span\>!!g | sed s!\(\<span\ data-field=\"Variacion\"\>!!g | xargs)";

	echo $VARIATION;
}

get_variation_from_rava() {
	#curl -X GET 'http://www.ravaonline.com/v2/empresas/perfil.php?e=erar' -s | grep "font-size:16px;font-weight:bold;color" | sed s/\<td\ style=\"font-family\:\ LatoWeb,\ Arial\"\>//g | sed s/\<span.*d\"\>// | sed s/\<.*//

	URL="http://www.ravaonline.com/v2/empresas/perfil.php?e=$1";

	VARIATION="$(curl -X GET $URL -s | grep "font-size:16px;font-weight:bold;color" | sed s/\<td\ style=\"font-family\:\ LatoWeb,\ Arial\"\>//g | sed s/\<span.*[dkn]\"\>// | sed s/%.*// | xargs)";

	echo $VARIATION;
}

print_variation() {
	NAME=$1
	VARIATION=$2;

	SIGN=${VARIATION:0:1};

	if [ "$SIGN" == "-" ]; then
		printf "$NAME --> ${RED}${VARIATION}%%${NC}\n";
	else
		printf "$NAME --> ${GREEN}${VARIATION}%%${NC}\n";
	fi;
}

for var in "$@"
do
	VARIATION="$(get_variation_from_rava $var)";
	print_variation "$var" "$VARIATION";
done
