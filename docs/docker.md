# Try with docker

Try what's in this repository without installing anything on your host, using
docker. This is a great way to test the setup and see if it works for you before
installing it on your machine.

## Step 1

Start an Ubuntu 24.04 container:

```sh
DOCKER_DEFAULT_PLATFORM=linux/amd64 docker run -it --name dotfiles-test ubuntu:24.04
```

## Step 2

Once inside the container, run as **root**:

```sh
# requirements
export DEBIAN_FRONTEND="noninteractive"
apt update && apt install -yq bc git curl sudo jq

# create a test user, as the setup script can't be run as root
useradd -m -s $(command -v bash) user
echo 'user    ALL=(ALL:ALL) NOPASSWD:ALL' > /etc/sudoers.d/user

# now become 'user'
su - user
```

Run as **user**:

```sh
# clone the repo
git clone https://github.com/pablon/dotfiles.git ~/dotfiles && cd ~/dotfiles/

# start the setup
./setup.sh
```

## Step 3

Once `setup.sh` has finished:

1. Hit `Ctrl+d` once to logout as 'user'
2. Run `su - user` to became 'user' again
3. Start playing around :rocket:
