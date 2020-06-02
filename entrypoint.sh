#!/bin/bash

declare -r config_dir=/data
declare -r POSTFIX_CONF=$config_dir/main.cf
declare -r config_file=/etc/postfix/main.cf
declare -r key_value_pair_regex="[^]+=[^]+"

# if volume with config, use it
if [ -f "${POSTFIX_CONF}" ];
then \
    rm -f /etc/main.cf
    ln -s "${POSTFIX_CONF}" /etc/main.cf
fi

for file in $config_dir/*; do
    file_name="$(basename -- $file)"
    [ $file_name != "main.cf" ] && cp -r $file /etc/postfix &&  postmap /etc/postfix/$file_name
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