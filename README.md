# Docker image with Combodo iTop

The image is based on [phusion/baseimage](https://hub.docker.com/r/phusion/baseimage/) and uses runit to manage services (apache, mysql, etc).

[![](https://images.microbadger.com/badges/version/vbkunin/itop.svg)](http://microbadger.com/images/vbkunin/itop "Get your own version badge on microbadger.com")
[![](https://images.microbadger.com/badges/image/vbkunin/itop.svg)](https://microbadger.com/images/vbkunin/itop "Get your own image badge on microbadger.com")

## Usage

Run new iTop 3.0.0-beta (see tags for other iTop versions) container named *my-itop*:
```
sudo docker run -d -p 8000:80 --name=my-itop vbkunin/itop:3.0.0-beta
```
Then go to [http://localhost:8000/](http://localhost:8000/) to continue the installation.

Use this command to get the MySQL user credentials:
```
sudo docker logs my-itop | grep -A7 -B1 "Your MySQL user 'admin' has password:"
```
or use username *root* with blank password.

Expose iTop extensions folder if you need it:
```
sudo docker run -d -p 8000:80 --name=my-itop -v /home/user/itop-extensions:/var/www/html/extensions vbkunin/itop:3.0.0-beta
```

### Image without MySQL

Starting from 2.6.0 you can get `base` image without MySQL database server (only Apache and PHP) to use with your own one:

```
sudo docker run -d -p 8000:80 --name=my-itop vbkunin/itop:3.0.0-beta-base
```

### Useful scripts and helpers

The image ships with several useful scripts you can run like this:
```
sudo docker exec my-itop /script-name.sh [script_params]
```

If you need the [iTop Toolkit](https://www.itophub.io/wiki/page?id=3_0_0:customization:datamodel#installing_the_toolkit) you can simply get this:
```
sudo docker exec my-itop /install-toolkit.sh
```

A cron setup helper is aboard:
```
sudo docker exec my-itop /setup-itop-cron.sh Cron Pa$5w0rD
```
Then you should create iTop user account with login *Cron* and password *Pa$5w0rD* and grant him Administrator profile. The third argument (optional) is the absolute path to the log file or `--without-logs` key. By default, the log file is `/var/log/itop-cron.log`.

There are other scripts:

 - make-itop-config-writable.sh (or you can use `conf-w` shortcut without the leading slash: `docker exec my-itop conf-w`)
 - make-itop-config-read-only.sh (or `conf-ro` shortcut: `docker exec my-itop conf-ro`)
 - update-russian-translations.sh - pull and install latest version from https://github.com/itop-itsm-ru/itop-rus

#### Developer's corner

If you're using this image for development (especially with PhpStorm), there are a few things for you.

- install-xdebug.sh – install [Xdebug](https://xdebug.org) PHP extension and setup it for [remote debugging](https://xdebug.org/docs/remote). Two arguments are `xdebug.remote_port` and `xdebug.idekey` (defaults are `9000` and `PHPSTORM`, respectively).
  ```
  sudo docker exec my-itop /install-xdebug.sh [remote_port] [idekey]
  ```

- start-itop-cron-debug.sh – start remote debugging of iTop background tasks script (cron.php). The first two arguments are iTop user and his password (`admin` and `password`) and the third argument is debug server configuration name (default is `localhost`) in PhpStorm which specified through PHP_IDE_CONFIG environment variable ([more details](https://www.jetbrains.com/help/phpstorm/zero-configuration-debugging-cli.html#d13593f7)).
  ```
  sudo docker exec my-itop /start-itop-cron-debug.sh [auth_user] [auth_pwd] [php_ide_server_name]
  ```

- enable-mysql-remote-connections.sh – add the `bind-address = 0.0.0.0` directive to the MySQL configuration to allow connections from outside the container.
  ```
  sudo docker exec my-itop /enable-mysql-remote-connections.sh
  ```
  Do not forget to expose the MySQL port with `-p 3306:3306` when running the container.

## Links

 - [Combodo](https://combodo.com)
 - [phusion/baseimage](https://hub.docker.com/r/phusion/baseimage/)
 - [iTop Russian community](http://community.itop-itsm.ru)
 - [Some extensions for iTop](https://knowitop.ru/store)

