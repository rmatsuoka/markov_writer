#!/bin/sh

export IFS=' 	
'
progname=$(basename "$0")
usage(){
	cat <<EOF
usage: $progname [var=var] < files
A wapper of markov_writer.awk for Japanese.
EOF
}
error(){
	printf '%s: %s\n' "$progname" "$1" 1>&2
	usage 1>&2
	exit ${2-1}
}

type mecab >/dev/null 2>&1 || error 'install mecab!'

while getopts hv opt; do
	case "$opt" in
	v) vflag="$OPTARG";;
	h) usage; exit 0;;
	?) usage 1>&2; exit 1;;
	esac
done
shift $((OPTIND - 1))

mecab |
	awk '{print $1}' |
	grep -v '^EOS$' |
	awk -f markov_writer.awk -- DOS='。' ${1+"$@"}
