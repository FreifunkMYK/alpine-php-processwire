##### This image is a fork from http://www.wordpressdocker.com project and being maintained. Fork it and change it fit your needs.

Full documentation for this project can be found here: not yet :-(

# Lightweight ProcessWire PHP7 PHP-FPM7 & Nginx Docker Image

Lightwight Docker image for the (latest) PHP-FPM and Nginx to run ProcessWire based on [AlpineLinux](http://alpinelinux.org)

* Image size only ~150MB !
* Very new packages (alpine:edge) 2016-07-21:
  * [PHP](http://pkgs.alpinelinux.org/package/main/x86/php) 7.0.13
  * [Nginx](http://pkgs.alpinelinux.org/package/main/x86/nginx) nginx/1.10.2
  * Memory usage is around 50mb on a simple install.

## A simple example
### Say you want to run a single site with Docker

#### First run the nginx proxy container
This sits in front of all of your sites at port 80 and 443 serving all your sites. It was automatically reconfigure itself and reload itself when you create a new ProcessWire site container.

```bash
docker run -d --name nginx -p 80:80 -p 443:443 -v /etc/nginx/htpasswd:/etc/nginx/htpasswd -v /etc/nginx/vhost.d:/etc/nginx/vhost.d:ro -v /etc/nginx/certs:/etc/nginx/certs -v /var/run/docker.sock:/tmp/docker.sock:ro etopian/nginx-proxy
```

#### Create directory to serve your files and copy all PW files into that directory
```bash
mkdir -p /data/sites/example.com/htdocs
```

The following user and group id are used, the files should be set to this:
User ID: 100
Group ID: 101

```bash
chown -R 100:101 /data/sites/example.com/htdocs
```

If you are using this image for development on a Linux box, then you will want to edit these files as a different user. You can do that using the following command:
```
setfacl -Rm u:<user>:rwX,g:<user>:rwX,d:g:<user>:rwX /data/sites/<site-domain>.com
```

#### Run a container for your database
```bash
docker run -d --name mariadb -p 172.17.0.1:3306:3306 -e MYSQL_ROOT_PASSWORD=myROOTPASSOWRD -v /data/mysql:/var/lib/mysql mariadb

```

#### Create your DB and import your DB Dump
```bash
# copy the db-dump into the database container
docker cp mydatabase.sql mariadb:/tmp/mydatabase.mysql
# open a shell inside the database container
docker exec -it mariadb bash
export TERM=xterm
cd /tmp
# login to mariadb
mysql -uroot -pmyROOTPASSOWRD

# create the db in mariadb
CREATE DATABASE example_com;
# create a db user
CREATE USER 'example_com'@'%' IDENTIFIED BY 'mydbpassword';
GRANT ALL PRIVILEGES ON  example_com.* TO 'example_com'@'%';
# import your db-dump
mysql -uroot -pmyROOTPASSOWRD example_com < mydatabase.mysql
# leave the mysql client
quit
# leave the container
exit

```

#### Configure ProcessWire to use that database
```php
/**
 * Installer: Database Configuration
 * 
 */
$config->dbHost = '172.17.0.1';
$config->dbName = 'example_com';
$config->dbUser = 'example_com';
$config->dbPass = 'mydbpassword';
$config->dbPort = '3306';

```

#### Run the ProcessWire container
```bash
sudo docker run -d --name example_com -e VIRTUAL_HOST=example.com,www.example.com -v /data/sites/example.com:/DATA -p 80:80 gebeer/alpine-php-processwire

```
#### Conclusion
Now you have 3 containers running: nginx with the nginx-proxy, example_com with your ProcessWire site and mariadb which serves the database.

If you set this up for development, you can now access the site at http://localhost.

Now that your containers are setup, you can stop/start the whole stack with
```bash
sudo docker (stop)start mariadb nginx example_com

```


### Volume structure

* `htdocs`: Webroot
* `logs`: Nginx/PHP error logs
* 

### Change php.ini values
modify files/php-fpm.conf

To modify php.ini variable, simply edit php-fpm.ini and add php_flag[variable] = value.

```
php_flag[display_errors] = on
```

Additional documentation: not yet here



