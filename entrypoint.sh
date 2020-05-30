#!/bin/bash -x

LC_ALL=C
LANG=C
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
export LC_ALL LANG PATH

declare -r config_dir=/data
declare -r key_value_pair_regex="[^]+=[^]+"

# if volume with config, use it

for file in $config_dir/*; do
    cp -r $file /etc/postfix
    file_name="$(basename -- $file)"
    [ $file_name != "main.cf" ] && postmap /etc/postfix/$file_name
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