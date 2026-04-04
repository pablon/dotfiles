# Try with docker

Try what's in this repository without installing anything on your host, using
docker. This is a great way to test the setup and see if it works for you before
installing it on your machine.

## Step 1

Start an Ubuntu 24.04 container invoking the whole setup process in one command:

```sh
DOCKER_DEFAULT_PLATFORM=linux/amd64 docker run -it --rm --name pablon-dotfiles ubuntu:24.04 sh -uelic '
 export DEBIAN_FRONTEND="noninteractive"
 apt update && apt install -yq sudo git zsh
 useradd -m -s /usr/bin/zsh test-user
 echo "test-user ALL=(ALL:ALL) NOPASSWD:ALL" >/etc/sudoers.d/test-user
 su -l test-user bash -c "cd ; git clone https://github.com/pablon/dotfiles.git && cd ./dotfiles/ && ./setup.sh"
'
```

## Step 2

Once `setup.sh` has finished:

1. **Logout** from 'testuser' by pressing `Ctrl-d` or running `exit` (_you'll see the root prompt_)
2. **Become** 'testuser' again, run: `su - testuser`
3. Start playing around :rocket:
