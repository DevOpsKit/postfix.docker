#!/bin/bash

set -o pipefail

LC_ALL=C
LANG=C
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
export LC_ALL LANG PATH

declare -r POSTFIX_CONF=/data/main.cf
declare -r config_file=/etc/postfix/main.cf
declare -r key_value_pair_regex="[^]+=[^]+"

# if volume with config, use it
if [ -f "${POSTFIX_CONF}" ];
then \
    rm -f /etc/main.cf
    ln -s "${POSTFIX_CONF}" /etc/main.cf
fi

# set config through commands
for argument; do
    if [[ $argument =~ $key_value_pair_regex ]]; then
        postconf -e $argument
    else
        echo "Wrong command argument: must be <key>=<value>."
    fi
done

# postfix start returns code 0 and the container exits, next line is to keep the process running.
postfix start 
tail -f /dev/null