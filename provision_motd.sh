#!/usr/bin/env bash

motd_script_dir="/vagrant/"
motd_script_name="motd.sh"

if [ -e $motd_script_dir$motd_script_name ]; then
	cp $motd_script_dir$motd_script_name /etc/
	echo "/bin/bash /etc/$motd_script_name" >> /etc/profile
fi
