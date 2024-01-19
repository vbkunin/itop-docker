# Docker image with Combodo iTop

![Docker Pulls](https://img.shields.io/docker/pulls/vbkunin/itop?logo=docker&link=https%3A%2F%2Fhub.docker.com%2Frepository%2Fdocker%2Fvbkunin%2Fitop)
![Docker Stars](https://img.shields.io/docker/stars/vbkunin/itop?logo=docker&link=https%3A%2F%2Fhub.docker.com%2Frepository%2Fdocker%2Fvbkunin%2Fitop)
![GitHub forks](https://img.shields.io/github/forks/vbkunin/itop-docker?link=https%3A%2F%2Fgithub.com%2Fvbkunin%2Fitop-docker)
![GitHub Repo stars](https://img.shields.io/github/stars/vbkunin/itop-docker?link=https%3A%2F%2Fgithub.com%2Fvbkunin%2Fitop-docker)

GitHub repo – https://github.com/vbkunin/itop-docker

The image is based on [phusion/baseimage](https://hub.docker.com/r/phusion/baseimage/) and uses runit to manage services (apache, mysql, etc).

## Usage

Run new iTop (see tags for specific iTop versions) container named *my-itop*:
```shell
sudo docker run -d -p 8000:80 --name=my-itop vbkunin/itop
```
Then go to [http://localhost:8000/](http://localhost:8000/) to continue the installation.

Use this command to get the MySQL user credentials:
```shell
sudo docker logs my-itop | grep -A7 -B1 "Your MySQL user 'admin' has password:"
```

If you want to persist iTop configuration and/or MySQL data between the container recreations, mount it as a volume:
```shell
sudo docker run -d -p 8080:80 --name=my-itop -v my-itop-conf-volume:/var/www/html/conf -v my-itop-db-volume:/var/lib/mysql vbkunin/itop
```
But don't forget to fix the rights to the folder (in any case, iTop setup wizard will remind you):
```shell
sudo docker exec my-itop chown www-data:www-data /var/www/html/conf
```

Expose iTop extensions folder if you need it:
```shell
sudo docker run -d -p 8000:80 --name=my-itop -v /home/user/itop-extensions:/var/www/html/extensions vbkunin/itop
```

### Image without MySQL

Уou can get `base` image without MySQL database server (only Apache and PHP) to use with your own one:

```shell
sudo docker run -d -p 8000:80 --name=my-itop vbkunin/itop:latest-base
```

### Useful scripts and helpers

The image ships with several useful scripts you can run like this:
```shell
sudo docker exec my-itop /script-name.sh [script_params]
```

If you need the [iTop Toolkit](https://www.itophub.io/wiki/page?id=3_0_0:customization:datamodel#installing_the_toolkit) you can simply get this:
```shell
sudo docker exec my-itop /install-toolkit.sh
```

A cron setup helper is aboard:
```shell
sudo docker exec my-itop /setup-itop-cron.sh Cron Pa$5w0rD
```
Then you should create iTop user account with login *Cron* and password *Pa$5w0rD* and grant him Administrator profile. The third argument (optional) is the absolute path to the log file or `--without-logs` key. By default, the log file is `/var/www/html/log/cron.log`.

There are other scripts:

- make-itop-config-writable.sh (or you can use `conf-w` shortcut without the leading slash: `docker exec my-itop conf-w`)
- make-itop-config-read-only.sh (or `conf-ro` shortcut: `docker exec my-itop conf-ro`)

#### Developer's corner

If you're using this image for development (especially with PhpStorm), there are a few things for you.

- install-xdebug.sh – install [Xdebug](https://xdebug.org) PHP extension and setup it for [remote debugging](https://xdebug.org/docs/remote). Two arguments are `xdebug.client_port` and `xdebug.idekey` (defaults are `9003` and `PHPSTORM`, respectively).
  ```shell
  sudo docker exec my-itop /install-xdebug.sh [client_port] [idekey]
  ```

- start-itop-cron-debug.sh – start remote debugging of iTop background tasks script (cron.php). The first two arguments are iTop user and his password (`admin` and `password`) and the third argument is debug server configuration name (default is `localhost`) in PhpStorm which specified through PHP_IDE_CONFIG environment variable ([more details](https://www.jetbrains.com/help/phpstorm/zero-configuration-debugging-cli.html#d13593f7)).
  ```shell
  sudo docker exec my-itop /start-itop-cron-debug.sh [auth_user] [auth_pwd] [php_ide_server_name]
  ```

- enable-mysql-remote-connections.sh – add the `bind-address = 0.0.0.0` directive to the MySQL configuration to allow connections from outside the container.
  ```shell
  sudo docker exec my-itop /enable-mysql-remote-connections.sh
  ```
  Do not forget to expose the MySQL port with `-p 3306:3306` when running the container.

## Building images

The project uses [multi-stage builds](https://docs.docker.com/build/building/multi-stage/) and a single Dockerfile to build both `base` (only Apache and PHP) and `full` images. Therefore, you have to specify the correct `--target` and the corresponding `--tag` when running the `docker build` command.

```shell
DOCKER_BUILDKIT=1 docker build \
  --target=base \
  --tag vbkunin/itop:3.1.1-base \
  --build-arg ITOP_DOWNLOAD_URL="https://sourceforge.net/projects/itop/files/itop/3.1.1-1/iTop-3.1.1-1-12561.zip/download" \
  -f Dockerfile .
```

```shell
DOCKER_BUILDKIT=1 docker build \
  --target=full \
  --tag vbkunin/itop:3.1.1 \
  --build-arg ITOP_DOWNLOAD_URL="https://sourceforge.net/projects/itop/files/itop/3.1.1-1/iTop-3.1.1-1-12561.zip/download" \
  -f Dockerfile .
```

The only mandatory build argument `ITOP_DOWNLOAD_URL` must contain a valid URL to the zip archive with the iTop release.

Multi-platform images for the Docker Hub are created and pushed using the `docker buildx` client:

```shell
docker buildx build \
  --tag vbkunin/itop:"${IMAGE_TAG:?}" \
  --platform="linux/arm64,linux/amd64" \
  --push \
  --target="${BUILD_TARGET:?}" \
  --build-arg ITOP_DOWNLOAD_URL="${ITOP_DOWNLOAD_URL:?}" \
  -f Dockerfile .
```

## Links

 - [GitHub repo](https://github.com/vbkunin/itop-docker)
 - [Combodo](https://combodo.com)
 - [phusion/baseimage](https://hub.docker.com/r/phusion/baseimage/)
 - [iTop Russian community forum](http://community.itop-itsm.ru) & [Telegram group](https://t.me/itopitsmru)
 - [Some extensions for iTop](https://knowitop.ru/store)

