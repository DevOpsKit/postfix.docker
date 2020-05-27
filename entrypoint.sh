#!/bin/bash -x

LC_ALL=C
LANG=C
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
export LC_ALL LANG PATH

declare -r POSTFIX_CONF=/data
declare -r config_dir=/etc/postfix
declare -r key_value_pair_regex="[^]+=[^]+"

# if volume with config, use it
for file in "$(ls -A  $POSTFIX_CONF)"; do
    cp $POSTFIX_CONF/$file $config_dir
    postmap $config_dir/$file
done

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