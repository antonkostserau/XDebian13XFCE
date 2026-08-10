#!/usr/bin/env bash

readonly DIR="$(cd "$(dirname "${BASH_SOURCE}")" && pwd)"

declare -r CPU_ARRAY=($(awk '/MHz/{print $4}' /proc/cpuinfo | cut -f1 -d"."))
readonly NUM_OF_CPUS="${#CPU_ARRAY[@]}"

MODEL_NAME=$(grep "model name" /proc/cpuinfo | cut -f2 -d ":" | sed -n 1p | sed -e 's/^[ \t]*//')
TEMP=$(sensors 2>/dev/null | awk '/[Cc]ore 0/{print $3}')

MORE_INFO="<tool>"
MORE_INFO+="┌ ${MODEL_NAME}\n"

STEP=0
SUM_FREQ=0

for CPU in "${CPU_ARRAY[@]}"; do
    SUM_FREQ=$(( SUM_FREQ + CPU ))
    
    if [[ -z "$TEMP" && $((STEP + 1)) -eq $NUM_OF_CPUS ]]; then
        MORE_INFO+="└─ CPU ${STEP}: ${CPU} MHz"
    else
        if [[ $((STEP + 1)) -eq $NUM_OF_CPUS && -z "$TEMP" ]]; then
             MORE_INFO+="└─ CPU ${STEP}: ${CPU} MHz"
        else
             MORE_INFO+="├─ CPU ${STEP}: ${CPU} MHz\n"
        fi
    fi
    let STEP+=1
done

if [ -n "$TEMP" ]; then
    MORE_INFO+="└─ Temperature: ${TEMP}"
fi

MORE_INFO+="</tool>"

AVG_FREQ=$(awk "BEGIN {printf \"%.2f\", $SUM_FREQ / $NUM_OF_CPUS / 1024}")

INFO="<txt>CPU: ${AVG_FREQ} GHz</txt>"

echo -e "${INFO}"
echo -e "${MORE_INFO}"
