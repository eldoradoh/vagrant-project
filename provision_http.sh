#!/usr/bin/env bash

## In this script I used a more efficient and flexible algorithm using the command find,
## but I also tried to minimize the use of this command for better performance.


# Install nginx Web server
apt-get install -y nginx

# Define root dir for nginx
root_dir='/var/www'

# Get current date and time
date_time=`date '+%d-%m-%Y|%H:%M:%S'`

# Define empty variable
nginx_default_file=""


# Check if file not exists and is not a symbolic link
if ! [ -L /var/www ]; then
	# Remove directory
	rm -rf $root_dir
	# Create symbolic link for shared folder vagrant
	ln -fs /vagrant $root_dir
fi


# Check if index file exists
if [ -e $root_dir"/index.htm" ]; then
	# Backup old index file with current date and time extension, create new index file and write into index file
	mv $root_dir"/index.htm" $root_dir"/index.htm.$date_time"
	touch $root_dir"/index.htm"
	echo "This is fresh new nginx index file" > $root_dir"/index.htm"

# Otherwise create new index file and write into index file
else
	touch $root_dir"/index.htm"
	echo "This is fresh new nginx index file" > $root_dir"/index.htm"
fi


# Find and check if nginx default config file exists (equal to 1)
if [ $(echo `find / -name 'default' 2>/dev/null | grep '/nginx/sites-enabled' | wc -l`) == 1 ]; then
	# Get full path to nginx config file
	nginx_default_file=$(find / -name 'default' 2>/dev/null | grep '/nginx/sites-enabled')

	# Create backup directory for saving current nginx default file
	# Remove words sites-enabled/default from string nginx_default_file
	backup_dir=$(echo $nginx_default_file | sed -e 's/\<sites-enabled\/default\>//g')

	# Check if file/dir not exists, create backup directory in nginx default directory
	if ! [ -e $backup_dir"backup_dir" ]; then
		mkdir $backup_dir"backup_dir"
	fi

	# Backup old config file default with current date and time extension, create new config file and write nginx server configuration into new file
	mv $nginx_default_file $backup_dir"backup_dir/default.$date_time"
	touch $nginx_default_file
	# Will serve static files on every location on Web server
	echo -e "server {\n\nlisten 80 default_server;\nlisten [::]:80 default_server ipv6only=on;\nserver_name localhost;\nroot $root_dir;\nindex index.html index.htm;\n\nlocation / {\ntry_files \$uri \$uri/ =404;\n}\n\nlocation ~* \.(js|css|png|jpg|jpeg|gif|ico)$ {\nexpires 30d;\nlog_not_found off;\n}\n\n}\n" > $nginx_default_file

# Otherwise Create new config file default and Check if file/dir not exists
else
	touch echo `find / -name 'sites-enabled' 2>/dev/null | grep 'nginx'`'/default'
	nginx_default_file=$(find / -name 'default' 2>/dev/null | grep '/nginx/sites-enabled')
	backup_dir=$(echo $nginx_default_file | sed -e 's/\<sites-enabled\/default\>//g')

	if ! [ -e $backup_dir"backup_dir" ]; then
		mkdir $backup_dir"backup_dir"
	fi
	# Will serve static files on every location on Web server
	echo -e "server {\n\nlisten 80 default_server;\nlisten [::]:80 default_server ipv6only=on;\nserver_name localhost;\nroot $root_dir;\nindex index.html index.htm;\n\nlocation / {\ntry_files \$uri \$uri/ =404;\n}\n\nlocation ~* \.(js|css|png|jpg|jpeg|gif|ico)$ {\nexpires 30d;\nlog_not_found off;\n}\n\n}\n" > $nginx_default_file
fi


# Restart nginx service
/etc/init.d/nginx restart
echo "VAGRANT PROVISION IS DONE !"
