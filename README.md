##### This image is a fork from http://www.wordpressdocker.com project and being maintained. Fork it and change it fit your needs.

Full documentation for this project can be found here: not yet :-(

# Lightweight ProcessWire PHP7 PHP-FPM7 & Nginx Docker Image

Lightwight Docker image for the (latest) PHP-FPM and Nginx to run ProcessWire based on [AlpineLinux](http://alpinelinux.org)

* Image size only ~131MB !
* Very new packages (alpine:edge) 2016-07-21:
  * [PHP](http://pkgs.alpinelinux.org/package/main/x86/php) 7.0.13
  * [Nginx](http://pkgs.alpinelinux.org/package/main/x86/nginx) nginx/1.10.2
  * Memory usage is around 50mb on a simple install.

## A simple example
### Say you want to run a single site on a VPS with Docker

```bash

mkdir -p /data/sites/example.com/htdocs

sudo docker run -e VIRTUAL_HOST=example.com,www.example.com -v /data/sites/example.com:/DATA -p 80:80 gebeer/alpine-php-processwire

```
The following user and group id are used, the files should be set to this:
User ID: 
Group ID: 

```bash
chown -R 100:101 /data/sites/example.com/htdocs
```

### Say you want to run a multiple PW sites on a VPS with Docker

```bash

sudo docker run -p 80:80 etopian/nginx-proxy
mkdir -p /data/sites/example.com/htdocs

sudo docker run -e VIRTUAL_HOST=example.com,www.example.com -v /data/sites/example.com:/DATA gebeer/alpine-processwire

mkdir -p /data/sites/etopian.net/htdocs
sudo docker run -e VIRTUAL_HOST=example.net,www.example.net -v /data/sites/example.net:/DATA gebeer/alpine-processwire
```

Populate /data/sites/example.com/htdocs and  /data/sites/example.net/htdocs with your PW files. See http://www.wordpressdocker.com if you need help on how to configure your database.

The following user and group id are used, the files should be set to this:
User ID: 
Group ID: 

```bash
chown -R 100:101 /data/sites/example.com/htdocs
```



### Volume structure

* `htdocs`: Webroot
* `logs`: Nginx/PHP error logs
* 

### PW-CLI

This image will hopefully soon include wireshell - an extendable ProcessWire command line interface.

```
docker exec -it <container_name> bash
su nginx
cd /DATA/htdocs
...
```

### Multisite

For each multisite you need to give the domain as the -e VIRTUAL_HOST parameter. For instance VIRTUAL_HOST=site1.com,www.site1.com,site2.com,www.site2.com ... if you wish to add more sites you need to recreate the container.

### Upload limit

The upload limit is 2 gigabyte.

### Change php.ini value
modify files/php-fpm.conf

To modify php.ini variable, simply edit php-fpm.ini and add php_flag[variable] = value.

```
php_flag[display_errors] = on
```

Additional documentation on not yet there



