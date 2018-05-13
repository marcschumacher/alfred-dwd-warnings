#!/bin/bash

RESULT=$(curl -s https://www.dwd.de/DWD/warnungen/warnapp/json/warnings.json | sed 's/^warnWetter\.loadWarnings(\(.*\));$/\1/g')
VORAB_INFO=$(echo "$RESULT" | /usr/local/bin/jq '{variables: {link: ("https://www.dwd.de/DE/wetter/warnungen_gemeinden/warnWetter_node.html")}, items: [.vorabInformation[][] | select(.regionName | test("'"$1"'"; "i")) | {title: .regionName, subtitle: .headline, arg: .regionName, variables: {desc: .description}}]}')
WARNUNGEN=$(echo "$RESULT" | /usr/local/bin/jq '{variables: {link: ("https://www.dwd.de/DE/wetter/warnungen_gemeinden/warnWetter_node.html")}, items: [.warnings[][] | select(.regionName | test("'"$1"'"; "i")) | {title: .regionName, subtitle: .headline, arg: .regionName, variables: {desc: .description}}]}')
echo "$VORAB_INFO" "$WARNUNGEN" | /usr/local/bin/jq -s add
