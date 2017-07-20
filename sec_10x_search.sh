#!/bin/sh


# IDK if this will work with GNU date.  Sorry.
START=`date -v-1d +%m/%d/%Y`
TODAY=`date +%m/%d/%Y`

#curl -f -s "https://searchwww.sec.gov/EDGARFSClient/jsp/EDGAR_MainAccess.jsp?search_text=cyber%20malicious%20intrusion%20virus&sort=Date&formType=Form10K&isAdv=true&stemming=false&numResults=100&fromDate=$START&toDate=$TODAY&numResults=100&prt=true" | grep opennew | sed  's/^.*opennew(//g' | sed 's/);.*$//g'


for formtype in 10k 10q; do
	for keyword in ransomware petya wannacry; do
		echo Forms $formtype mentioning $keyword from $START to $TODAY
		curl -f -s "https://searchwww.sec.gov/EDGARFSClient/jsp/EDGAR_MainAccess.jsp?search_text=${keyword}&formType=Form${formtype}&isAdv=true&stemming=false&numResults=100&fromDate=$START&toDate=$TODAY&numResults=100&prt=true" | grep opennew | sed  's/^.*opennew(//g' | sed 's/);.*$//g'
	done
done




