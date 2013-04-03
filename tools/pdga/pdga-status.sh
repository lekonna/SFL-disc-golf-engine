#!/bin/bash

PDGANUM=$1
PREFIX=${2:-kisakonetesti_}
[ -z "$1" ] && echo "error: pdga_num argument missing" && exit 1

URL="http://www.pdga.com/player-stats?PDGANum="
DATA=$(lynx -dump ${URL}${PDGANUM})
RATING=$(echo $DATA | grep "Current Rating: " | sed -re 's,.*Current Rating: ([0-9]+).*,\1,')
CLASS=$(echo $DATA | grep "Classification: " | sed -re 's,.*Classification: ([A-Za-z]+).*,\1,')
RETVAL=$?

RATING=${RATING:-0}
if [ "${CLASS}" == "Amateur" ]; then
  CLASS="amateur"
elif [ "${CLASS}" == "Professional" ]; then
  CLASS="professional"
else
  CLASS="unknown"
fi

echo ${RATING} ${CLASS}
