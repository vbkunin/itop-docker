# Docker image with Combodo iTop

Starting from 2.5.0-beta the image is based on [phusion/baseimage](https://hub.docker.com/r/phusion/baseimage/) and uses runit to manage services (apache, mysql, etc).

[![](https://images.microbadger.com/badges/version/vbkunin/itop.svg)](http://microbadger.com/images/vbkunin/itop "Get your own version badge on microbadger.com")
[![](https://images.microbadger.com/badges/image/vbkunin/itop.svg)](https://microbadger.com/images/vbkunin/itop "Get your own image badge on microbadger.com")

## Usage

Run new iTop 2.5.0 (see tags for other iTop versions) container named *my-itop*:
```
sudo docker run -d -p 80:80 --name=my-itop vbkunin/itop:2.5.0
```
Then go to [http://localhost/](http://localhost/) to continue the installation.

Use this command to get the MySQL user credentials:
```
sudo docker logs my-itop | grep -C4 "mysql -uadmin -p"
```
or use username *root* with blank password.

Expose MySQL port or iTop extensions folder if you need it:
```
sudo docker run -d -p 80:80 -p 3306:3306 --name=my-itop -v /home/user/itop-extensions:/var/www/html/extensions vbkunin/itop:2.5.0
```

The image ships with several useful scripts you can run like this:
```
sudo docker exec my-itop /script-name.sh [script-params]
```

If you need the [iTop Toolkit](https://www.itophub.io/wiki/page?id=2_4_0:customization:datamodel#installing_the_toolkit) you can simply get this:
```
sudo docker exec my-itop /install-toolkit.sh
```

A cron setup helper is aboard:
```
sudo docker exec my-itop /setup-itop-cron.sh Cron Pa$5w0rD
```
Then you should create iTop user account with login *Cron* and password *Pa$5w0rD* and grant him Administrator profile. Starting from v2.3.3 the third argument (optional) is the absolute path to the log file or `--without-logs` key. By default, the log file is `/var/log/itop-cron.log`.

There are other scripts:

 - make-itop-config-writable.sh (or you can use `conf-w` shortcut without the leading slash: `docker exec my-itop conf-w`)
 - make-itop-config-read-only.sh (or `conf-ro` shortcut: `docker exec my-itop conf-ro`)
 - update-russian-translations.sh - pull and install latest version from https://github.com/itop-itsm-ru/itop-rus

## Links

 - [Combodo](https://combodo.com)
 - [phusion/baseimage](https://hub.docker.com/r/phusion/baseimage/)
 - [iTop Russian community](http://community.itop-itsm.ru)
 - [Some extensions for iTop](https://github.com/knowitop)

