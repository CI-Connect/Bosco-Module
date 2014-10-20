#!/bin/sh

from=$(dirname "$0")
base="$1"
modlib="$2"

if [ -z "$base" -o -z "$modlib" -o "$base" = "-h" -o "$base" = "--help" ]; then
	echo >&2 "usage: $0 software-install-directory modulefiles-directory"
	exit 2
fi

mkdir -p "$base" 2>/dev/null
mkdir -p "$base/bin" 2>/dev/null
mkdir -p "$modlib/connect" 2>/dev/null

status () {
	echo "$@" ...
}

if [ ! -d "$base" ]; then
	echo >&2 "Cannot create $base - cannot install."
	exit 10
fi

status Setting up the Connect module
sed -e "s!@CONNECTDIR@!$base!g" \
	<"$from/modules/connect.in" >"$modlib/connect/connect"

status Installing the Connect client
rsync -a bosco "$base/connect-client"

status Installing Connect user commands
rsync -a connect/. "$base/."
cp -p scripts/tutorial/tutorial "$base/bin/"

