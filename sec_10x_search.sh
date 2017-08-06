#!/bin/sh



# Permutations of keywords method via Satō Katsura as posted at https://unix.stackexchange.com/a/310094 (retrieved 2017-08-02)

declare -a list=(intrusion virus ransomware petya wannacry)

show() {
    local -a results=()
    let idx=$2
    for (( j = 0; j < $1; j++ )); do
        if (( idx % 2 )); then results=("${results[@]}" "${list[$j]}"); fi
        let idx\>\>=1
    done
    echo "${results[@]}"
}

let n=${#list[@]}

# End of stuff from https://unix.stackexchange.com/a/310094

# IDK if this will work with GNU date.  Sorry.
START=`date -v-1d +%m/%d/%Y`
TODAY=`date +%m/%d/%Y`


# Write stuff to temp file in anticipation of groveling thru it
# in a second pass for some reason.

TMPFILE="$(mktemp -t sec_10x_search)"

trap "rm -f '$TMPFILE'" EXIT INT HUP TERM

#10q 8k

for formtype in 10k ; do
	for (( i = 1; i < 2**n; i++ )); do
		KEYWORDS=$(show $n $i)
		SEARCHSTRING=$(echo $KEYWORDS | sed 's/ /\&search_text=/g')
		#echo Processing $formtype for $KEYWORDS   from $START to $TODAY >> "${TMPFILE}"	
		curl -f -s "https://searchwww.sec.gov/EDGARFSClient/jsp/EDGAR_MainAccess.jsp?search_text=${SEARCHSTRING}&formType=Form${formtype}&isAdv=true&stemming=false&numResults=100&fromDate=$START&toDate=$TODAY&numResults=100&prt=true" | grep opennew | sed  's/^.*opennew(//g' | sed 's/);.*$//g' | head -1 >> "${TMPFILE}"
	done
done





