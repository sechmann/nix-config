#!/usr/bin/env bash
url="$1"

urlencode() {
	local string="${1}"
	local strlen=${#string}
	local encoded=""
	local pos c o

	for ((pos = 0; pos < strlen; pos++)); do
		c=${string:$pos:1}
		case "$c" in
		[-_.~a-zA-Z0-9]) o="${c}" ;;
		*) printf -v o '%%%02x' "'$c" ;;
		esac
		encoded+="${o}"
	done
	echo "${encoded}"
}

handle_google_login() {
	account="$(gcloud auth list --filter='active' --format 'value(account)')"

	echo "ext+container:name=${account}&url=$(urlencode "$1&autoAccountSelect=${account}")"
}

open_in_container() {
	if [[ -z $2 ]]; then
		account="$(gcloud auth list --filter='active' --format 'value(account)')"
	else
		account="$2"
	fi

	echo "ext+container:name=${account}&url=$(urlencode "$1")"
}

if [[ $url =~ https://accounts.google.com/o/oauth2/auth ]]; then
	url=$(handle_google_login "$url")
elif [[ $url =~ https://(www\.)?.*nav\.cloud\.nais\.io ]]; then
	url=$(open_in_container "$url" "vegar.sechmann.molvig@nav.no")
elif [[ $url =~ https://(www\.)?.*\.nais\.io ]]; then
	url=$(open_in_container "$url" "vegar@nais.io")
elif [[ $url =~ https://(www\.)?.*twitch\.com ]]; then
	url=$(open_in_container "$url" "personal")
elif [[ $url =~ https://(www\.)?youtube.com ]] || [[ $url =~ https://(www.)?youtu.be ]]; then
	mpv "$url"
	exit 0
elif [[ $url =~ https?://[^.]*.?medium.com ]]; then
	url="${url//medium.com/scribe.rip}"
fi

zen "$url"
