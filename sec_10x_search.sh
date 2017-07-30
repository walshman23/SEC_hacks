#!/bin/sh


# IDK if this will work with GNU date.  Sorry.
START=`date -v-1d +%m/%d/%Y`
TODAY=`date +%m/%d/%Y`


# Write stuff to temp file in anticipation of groveling thru it
# in a second pass for some reason.

TMPFILE="$(mktemp -t sec_10x_search)"

trap "rm -f '$TMPFILE'" EXIT INT HUP TERM


for formtype in 10k 10q; do
	for keyword in ransomware petya wannacry; do
		echo Forms $formtype mentioning $keyword from $START to $TODAY >> "${TMPFILE}"
		curl -f -s "https://searchwww.sec.gov/EDGARFSClient/jsp/EDGAR_MainAccess.jsp?search_text=${keyword}&formType=Form${formtype}&isAdv=true&stemming=false&numResults=100&fromDate=$START&toDate=$TODAY&numResults=100&prt=true" | grep opennew | sed  's/^.*opennew(//g' | sed 's/);.*$//g' | head -1 >> "${TMPFILE}"
	done
done
cat "${TMPFILE}"




