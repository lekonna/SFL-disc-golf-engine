#!/bin/bash

# default settings, can be overridden from cmdline
USER=${1:-""}
PASS=${2:-""}
DB=${3:-""}
PREFIX=${4:-""}

# run update over all players having pdga number in profile
SQL="SELECT player_id, pdga FROM ${PREFIX}Player WHERE pdga IS NOT NULL ORDER BY pdga;"
mysql -u ${USER} --password=${PASS} ${DB} -s -e "${SQL}" | \
while read PLAYERID PDGANUM; do
	OUTPUT=$(./pdga-status.sh "${PDGANUM}")
	RATING=$(echo $OUTPUT | cut -f1 -d" ")
	STATUS=$(echo $OUTPUT | cut -f2 -d" ")

	if [ "${RATING}" == "0" ]; then
		echo "-- rating 0 for player_id ${PLAYERID}"
	elif [ "${STATUS}" == "unknown" ]; then
		echo "-- status ${STATUS} for player_id ${PLAYERID}"
	else
		UPDATE="UPDATE ${PREFIX}Player SET pdga_status = '${STATUS}', pdga_rating = ${RATING} WHERE player_id = ${PLAYERID};"
		echo $UPDATE
		mysql -u ${USER} --password=${PASS} ${DB} -s -e "${UPDATE}"
	fi
done

