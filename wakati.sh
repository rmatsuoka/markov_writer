#!/bin/sh

export IFS=' 	
'
progname=$(basename "$0")
usage(){
	cat <<EOF
usage: $progname [file...]
input: Japanese texts
EOF
}
error(){
	printf '%s: %s\n\n' "$progname" "$1" 1>&2
	usage 1>&2
	exit ${2-1}
}

while [ $# -gt 0 ]; do
	case "$1" in
	-h|--help)
		usage
		exit 0
		;;
	--)	shift
		break
		;;
	-?*)	error "illegal option -- ${1#-}"
		;;
	*)	break
		;;
	esac
	shift
done

type mecab >/dev/null 2>&1 || error 'install mecab!'

mecab ${1+"$@"} |
	awk '{print $1}' |
	grep -v '^EOS$'
