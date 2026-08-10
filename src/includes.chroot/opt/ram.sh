#!/usr/bin/env bash

readonly DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

readonly TOTAL=$(free -b | awk '/^[Mm]em/{$2 = $2 / 1073741824; printf "%.2f", $2}')
readonly USED=$(free -b | awk '/^[Mm]em/{$3 = $3 / 1073741824; printf "%.2f", $3}')
readonly FREE=$(free -b | awk '/^[Mm]em/{$4 = $4 / 1073741824; printf "%.2f", $4}')
readonly SHARED=$(free -b | awk '/^[Mm]em/{$5 = $5 / 1073741824; printf "%.2f", $5}')
readonly CACHED=$(free -b | awk '/^[Mm]em/{$6 = $6 / 1073741824; printf "%.2f", $6}')
readonly AVAILABLE=$(free -b | awk '/^[Mm]em/{$7 = $7 / 1073741824; printf "%.2f", $7}')

readonly SWP_TOTAL=$(free -b | awk '/^[Ss]wap/{$2 = $2 / 1073741824; printf "%.2f", $2}')
readonly SWP_USED=$(free -b | awk '/^[Ss]wap/{$3 = $3 / 1073741824; printf "%.2f", $3}')
readonly SWP_FREE=$(free -b | awk '/^[Ss]wap/{$4 = $4 / 1073741824; printf "%.2f", $4}')

INFO+="<txt>"
INFO+="RAM: ${USED} / ${TOTAL} GB"
INFO+="</txt>"

MORE_INFO="<tool>"
MORE_INFO+="┌ RAM\n"
MORE_INFO+="├─ Used: ${USED} GB\n"
MORE_INFO+="├─ Free: ${FREE} GB\n"
MORE_INFO+="├─ Shared: ${SHARED} GB\n"
MORE_INFO+="├─ Cache: ${CACHED} GB\n"
MORE_INFO+="└─ Total: ${TOTAL} GB"
MORE_INFO+="\n\n"
MORE_INFO+="┌ SWAP\n"
MORE_INFO+="├─ Used: ${SWP_USED} GB\n"
MORE_INFO+="├─ Free: ${SWP_FREE} GB\n"
MORE_INFO+="└─ Total: ${SWP_TOTAL} GB"
MORE_INFO+="</tool>"

echo -e "${INFO}"
echo -e "${MORE_INFO}"
