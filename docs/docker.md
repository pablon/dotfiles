# Try with docker

Try what's in this repository without installing anything on your host, using docker. This is a great way to test the
setup and see if it works for you before installing it on your machine.

Start an Ubuntu [latest](https://hub.docker.com/_/ubuntu/tags) container invoking the whole setup process in one
command:

```bash
DOCKER_DEFAULT_PLATFORM=linux/amd64 docker run -it --rm --name test-dotfiles ubuntu:latest bash -lc '
 export DEBIAN_FRONTEND="noninteractive"
 apt update && apt upgrade -yq && apt install -yq sudo git zsh
 useradd -m -s /usr/bin/zsh test-dotfiles
 echo "test-dotfiles ALL=(ALL:ALL) NOPASSWD:ALL" >/etc/sudoers.d/test-dotfiles
 su -l test-dotfiles bash -c "cd ; git clone https://github.com/pablon/dotfiles.git && cd ./dotfiles/ && ./setup.sh install" ; exec su -l test-dotfiles'
```

Once `setup.sh` has finished you can start playing around :rocket:

When you logout, the container is gone: no cleanup required.

---

![docker](docker.gif)
