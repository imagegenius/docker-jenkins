<!-- DO NOT EDIT THIS FILE MANUALLY -->
<!-- Please read https://github.com/imagegenius/docker-jenkins/blob/main/.github/CONTRIBUTING.md -->

# [imagegenius/jenkins](https://github.com/imagegenius/docker-jenkins)

[![GitHub Release](https://img.shields.io/github/release/imagegenius/docker-jenkins.svg?color=007EC6&labelColor=555555&logoColor=ffffff&style=for-the-badge&logo=github)](https://github.com/imagegenius/docker-jenkins/releases)
[![GitHub Package Repository](https://shields.io/badge/GitHub%20Package-blue?logo=github&logoColor=ffffff&style=for-the-badge)](https://github.com/imagegenius/docker-jenkins/packages)
[![Jenkins Build](https://img.shields.io/jenkins/build?labelColor=555555&logoColor=ffffff&style=for-the-badge&jobUrl=https%3A%2F%2Fci.imagegenius.io%2Fjob%2FDocker-Pipeline-Builders%2Fjob%2Fdocker-jenkins%2Fjob%2Fmain%2F&logo=jenkins)](https://ci.imagegenius.io/job/Docker-Pipeline-Builders/job/docker-jenkins/job/main/)
[![IG CI](https://img.shields.io/badge/dynamic/yaml?color=007EC6&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=CI&query=CI&url=https%3A%2F%2Fci-tests.imagegenius.io%2Fjenkins%2Flatest-main%2Fci-status.yml)](https://ci-tests.imagegenius.io/jenkins/latest-main/index.html)

Jenkins is the leading open-source automation server. Built with Java, it provides over 1,800 plugins to support automating virtually anything, so that humans can spend their time doing things machines cannot.

[![jenkins](https://camo.githubusercontent.com/1babb15d046739f64d24c9a3424dd912a88683894f6f2307a969501ad84739f8/68747470733a2f2f7777772e6a656e6b696e732e696f2f696d616765732f6a656e6b696e732d6c6f676f2d7469746c652d6461726b2e737667)](https://jenkins.io/)

## Supported Architectures

We use Docker manifest for cross-platform compatibility. More details can be found on [Docker's website](https://distribution.github.io/distribution/spec/manifest-v2-2/#manifest-list).

To obtain the appropriate image for your architecture, simply pull `ghcr.io/imagegenius/jenkins:latest`. Alternatively, you can also obtain specific architecture images by using tags.

This image supports the following architectures:

| Architecture | Available | Tag |
| :----: | :----: | ---- |
| x86-64 | ✅ | amd64-\<version tag\> |
| arm64 | ✅ | arm64v8-\<version tag\> |
| armhf | ❌ | |

## Version Tags

This image offers different versions via tags. Be cautious when using unstable or development tags, and read their descriptions carefully.

| Tag | Available | Description |
| :----: | :----: |--- |
| latest | ✅ | Latest (weekly) Jenkins release with an Alpine base. |

## Application Setup

The WebUI can be found at `http://your-ip:8080`, the admin password for initial setup is printed in the logs, follow the setup steps to configure Jenkins.

This image has full support for PUID/PGID and docker-mods, so you could use the [docker-in-docker](https://github.com/linuxserver/docker-mods/tree/universal-docker-in-docker) mod from linuxserver to run docker within this container

## Usage

Example snippets to start creating a container:

### Docker Compose

```yaml
---
services:
  jenkins:
    image: ghcr.io/imagegenius/jenkins:latest
    container_name: jenkins
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC
      - "CLI_ARGS=-Xms1G -Xmx4G" #optional
    volumes:
      - path_to_appdata:/config
    ports:
      - 8080:8080
      - 50000:50000
    restart: unless-stopped
```

### Docker CLI ([Click here for more info](https://docs.docker.com/engine/reference/commandline/cli/))

```bash
docker run -d \
  --name=jenkins \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -e CLI_ARGS="-Xms1G -Xmx4G" `#optional` \
  -p 8080:8080 \
  -p 50000:50000 \
  -v path_to_appdata:/config \
  --restart unless-stopped \
  ghcr.io/imagegenius/jenkins:latest
```

## Parameters

To configure the container, pass variables at runtime using the format `<external>:<internal>`. For instance, `-p 8080:80` exposes port `80` inside the container, making it accessible outside the container via the host's IP on port `8080`.

| Parameter | Function |
| :----: | --- |
| `-p 8080` | WebUI Port |
| `-p 50000` | Slave Port |
| `-e PUID=1000` | UID for permissions - see below for explanation |
| `-e PGID=1000` | GID for permissions - see below for explanation |
| `-e TZ=Etc/UTC` | Specify a timezone to use, see this [list](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List). |
| `-e CLI_ARGS=-Xms1G -Xmx4G` | Optionally specify any CLI variables you want to launch java with. Misconfiguration will cause jenkins to fail to start! |
| `-v /config` | Jenkins Home (appdata) |

## Umask for running applications

All of our images allow overriding the default umask setting for services started within the containers using the optional -e UMASK=022 option. Note that umask works differently than chmod and subtracts permissions based on its value, not adding. For more information, please refer to the Wikipedia article on umask [here](https://en.wikipedia.org/wiki/Umask).

## User / Group Identifiers

To avoid permissions issues when using volumes (`-v` flags) between the host OS and the container, you can specify the user (`PUID`) and group (`PGID`). Make sure that the volume directories on the host are owned by the same user you specify, and the issues will disappear.

Example: `PUID=1000` and `PGID=1000`. To find your PUID and PGID, run `id user`.

```bash
  $ id username
    uid=1000(dockeruser) gid=1000(dockergroup) groups=1000(dockergroup)
```


## Updating the Container

Most of our images are static, versioned, and require an image update and container recreation to update the app. We do not recommend or support updating apps inside the container. Check the [Application Setup](#application-setup) section for recommendations for the specific image.

Instructions for updating containers:

### Via Docker Compose

* Update all images: `docker-compose pull`
  * or update a single image: `docker-compose pull jenkins`
* Let compose update all containers as necessary: `docker-compose up -d`
  * or update a single container: `docker-compose up -d jenkins`
* You can also remove the old dangling images: `docker image prune`

### Via Docker Run

* Update the image: `docker pull ghcr.io/imagegenius/jenkins:latest`
* Stop the running container: `docker stop jenkins`
* Delete the container: `docker rm jenkins`
* Recreate a new container with the same docker run parameters as instructed above (if mapped correctly to a host folder, your `/config` folder and settings will be preserved)
* You can also remove the old dangling images: `docker image prune`

## Versions

* **24.04.24:** - rebase to alpine 3.19
* **06.05.23:** - Add CLI variables.
* **27.03.23:** - Initial release.
