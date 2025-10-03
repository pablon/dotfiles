#!/usr/bin/env bash
##########################################################
# Description: Installs os required tools.
# Author: https://github.com/pablon
##########################################################

set -a
source "$(dirname "${0}")/.functions" || exit 1
detect_os

export INSTALL_OPTS='--owner=root --group=root --mode=0755'
export PKGLIST_APT="$(dirname "${0}")/pkglist.apt"       # https://packages.ubuntu.com/
export PKGLIST_ASDF="$(dirname "${0}")/pkglist.asdf"     # https://packages.ubuntu.com/
export PKGLIST_BREW="$(dirname "${0}")/pkglist.brew"     # https://formulae.brew.sh/formula/
export PKGLIST_PACMAN="$(dirname "${0}")/pkglist.pacman" # https://archlinux.org/packages/

# https://docs.github.com/rest/overview/resources-in-the-rest-api#rate-limiting
if [ "${GITHUB_TOKEN}" ]; then
	export GITHUB_AUTH="-H 'Authorization: Bearer ${GITHUB_TOKEN}'"
fi

# ===============================================================
# os packages

function do_prepare_darwin() {
	local PACKAGE_LIST="${PKGLIST_BREW}"
	# Detect Apple Silicon chipset + install rosetta
	if [[ "$(uname)" == "Darwin" ]] && [[ "$(uname -m)" == "arm64" ]]; then
		if (! arch -x86_64 /usr/bin/true 2>/dev/null); then
			echo -e "${YELLOW}HEY! I've detected you're running an Apple Silicon Chip - ${CYAN}I will install Rosetta2 now${NONE}"
			sleep 2
			divider
			_info "Installing ${YELLOW}rosetta2"
			/usr/sbin/softwareupdate --install-rosetta --agree-to-license
			echo -e "/usr/sbin/softwareupdate --install-rosetta --agree-to-license${NONE} = ${YELLOW}$?${NONE}"
		fi
	fi
	# Install Homebrew
	if (command -v brew &>/dev/null) || [ "$(uname -m)" != "amd64" ]; then
		exit 0
	else
		divider
		_info "Installing ${YELLOW}homebrew"
		NONINTERACTIVE=1 bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
		# verify
		if [ "$?" -ne "0" ] || (! command -v brew config &>/dev/null); then
			_error "Something went wrong while installing homebrew. Aborting."
			exit 1
		fi
		# Disable brew analytics
		brew analytics off
	fi
	PACKAGES="${PKGLIST_BREW}"
	if [ -r "${PACKAGES}" ] && [ -s "${PACKAGES}" ]; then
		divider
		_info "Installing packages from ${PACKAGES}"
		install_pkg_darwin $(xargs <"${PACKAGES}") || {
			_error "Failed to install packages from ${PACKAGES}"
			exit 1
		}
	else
		_error "Package list ${PACKAGES} not found or is empty."
		exit 1
	fi

	# docker-buildx is a Docker plugin. For Docker to find this plugin, symlink it:
	if [ -x "/usr/local/opt/docker-buildx/bin/docker-buildx" ]; then
		if [ ! -d "${HOME}/.docker/cli-plugins" ]; then
			mkdir -p "${HOME}/.docker/cli-plugins"
			ln -sfn /usr/local/opt/docker-buildx/bin/docker-buildx "${HOME}/.docker/cli-plugins/docker-buildx"
		fi
	fi
}

function do_apt_init() {
	${SUDO} apt update ${APT_OPTS} &&
		${SUDO} apt upgrade ${APT_OPTS} &&
		${SUDO} apt dist-upgrade ${APT_OPTS} &&
		${SUDO} apt install ${APT_OPTS} apt-utils build-essential software-properties-common

	source /etc/os-release
	if [[ "${ID}" == "ubuntu" ]]; then
		# for latest neovim
		divider
		_info "Adding apt repo ppa:neovim-ppa/unstable"
		${SUDO} add-apt-repository -y ppa:neovim-ppa/unstable
		if [[ "${VERSION_ID%%.*}" -lt "24" ]]; then
			# add git-core apt repo for older ubuntu versions
			divider
			_info "Adding apt repo ppa:git-core/ppa"
			${SUDO} add-apt-repository -y ppa:git-core/ppa
		fi
		${SUDO} apt update ${APT_OPTS}
	fi
}

function do_prepare_debian() {
	do_apt_init
	PACKAGES="${PKGLIST_APT}"
	if [ -r "${PACKAGES}" ] && [ -s "${PACKAGES}" ]; then
		divider
		_info "Installing packages from ${PACKAGES}"
		install_pkg_debian $(xargs <"${PACKAGES}") || {
			_error "Failed to install packages from ${PACKAGES}"
			exit 1
		}
	else
		_error "Package list ${PACKAGES} not found or is empty."
		exit 1
	fi
}

function do_prepare_ubuntu() {
	do_prepare_debian
}

function do_prepare_arch() {
	${SUDO} pacman ${PACMAN_OPTS} -Syu &&
		${SUDO} pacman ${PACMAN_OPTS} -Sy base base-devel
	PACKAGES="${PKGLIST_PACMAN}"
	if [ -r "${PACKAGES}" ] && [ -s "${PACKAGES}" ]; then
		divider
		_info "Installing packages from ${PACKAGES}"
		install_pkg_arch $(xargs <"${PACKAGES}") || {
			_error "Failed to install packages from ${PACKAGES}"
			exit 1
		}
	else
		_error "Package list ${PACKAGES} not found or is empty."
		exit 1
	fi
}

function do_asdf() {
	[ "${OS}" == "Darwin" ] && return 0 # macos uses brew
	divider
	local GITHUB_PROJECT="asdf-vm/asdf"
	local PROGRAM="$(basename "${GITHUB_PROJECT}")"
	local INSTALL_TARGET='/usr/local/bin'
	local LATEST="$(curl ${GITHUB_AUTH} -s "https://api.github.com/repos/${GITHUB_PROJECT}/releases/latest" | jq -r ".tag_name")" # v0.18.0
	if [ -z "${LATEST}" ] || [ "${LATEST}" == "null" ]; then
		_error "could not determine asdf latest version from ${CYAN}https://api.github.com/repos/${GITHUB_PROJECT}/releases/latest"
		return 1
	fi
	if (type asdf &>/dev/null); then
		local CURRENT_VER="$(asdf version | awk '{print $1}')"
		if [[ "${CURRENT_VER}" == "${LATEST}" ]]; then
			_info "asdf is up to date -- skipping"
			return 0
		fi
	else
		local TARBALL="${PROGRAM}.tar.gz"
		local PLATFORM="$(uname)"
		local PLATFORM="${PLATFORM,,}"
		case "$(uname -m)" in
		'x86_64')
			ARCH="amd64"
			;;
		'aarch64' | 'arm64')
			ARCH="arm64"
			;;
		*)
			_error "arch $(uname -m) not supported"
			return 2
			;;
		esac
		(
			_info "Installing asdf"
			cd /tmp/ &&
				curl -fSL --progress-bar -o "${TARBALL}" "https://github.com/${GITHUB_PROJECT}/releases/download/${LATEST}/${PROGRAM}-${LATEST}-${PLATFORM}-${ARCH}.tar.gz" &&
				tar xfz ${TARBALL} ${PROGRAM} &&
				sudo install ${INSTALL_OPTS} ${PROGRAM} ${INSTALL_TARGET}/ &&
				rm -f ${PROGRAM}* ||
				_error "asdf install failed" &&
				exit 3
		)
	fi
	export PATH="${ASDF_DATA_DIR:-${HOME}/.asdf}/shims:${PATH}"

	# add lazydocker source url
	asdf plugin add lazydocker https://github.com/comdotlinux/asdf-lazydocker.git 2>/dev/null
}

function do_asdf_packages() {
	local PATH="${ASDF_DATA_DIR:-${HOME}/.asdf}/shims:${PATH}"
	# install packages
	PACKAGES="${PKGLIST_ASDF}"
	if [ -r "${PACKAGES}" ] && [ -s "${PACKAGES}" ]; then
		divider
		_info "Installing asdf packages"
		# install_pkg_asdf $(xargs <"${PACKAGES}") || {
		for i in $(grep -v '#' "${PACKAGES}"); do
			if (! type ${i} &>/dev/null); then
				install_pkg_asdf "${i}"
			fi
		done
		asdf current
	else
		_error "Package list ${PACKAGES} not found or is empty."
		exit 1
	fi
}

# ===============================================================
# useful tools

function do_additional_tools() {

	# helm plugins
	if (type helm &>/dev/null); then
		_info "Installing helm plugins"
		helm plugin install https://github.com/databus23/helm-diff 2>/dev/null
		helm plugin install https://github.com/jkroepke/helm-secrets 2>/dev/null
		helm plugin install https://github.com/aslafy-z/helm-git 2>/dev/null
	fi

	local PATH="${ASDF_DATA_DIR:-${HOME}/.asdf}/shims:${PATH}"
	# rustup
	divider
	if [ ! -f "${HOME}/.rustup/settings.toml" ]; then
		_info "Installing ${CYAN}rustup" &&
			curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -q -y
	fi

	if [ "$(uname)" == "Linux" ]; then
		# atuin
		if (! type atuin &>/dev/null); then
			divider
			_info "Installing ${CYAN}atuin" &&
				curl --proto '=https' --tlsv1.2 -LsSf https://github.com/atuinsh/atuin/releases/latest/download/atuin-installer.sh | bash
		else
			_success "atuin is already installed"
			atuin --version
		fi

		# starship
		if (! type starship &>/dev/null); then
			divider
			_info "Installing ${CYAN}starship"
			curl -fsSL https://starship.rs/install.sh | sudo sh -s -- -y
		else
			_success "starship is already installed"
			starship -V
		fi

		# yazi has its own function
		if (! type yazi &>/dev/null); then
			divider
			_info "Installing ${CYAN}yazi"
			install_yazi
		else
			_success "yazi is already installed"
			yazi -V
		fi
	fi

	# import shell history
	eval "atuin import zsh" 2>/dev/null
}

function install_yazi() {
	export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
	local GITHUB_PROJECT="sxyazi/yazi"
	local PROGRAM="$(basename "${GITHUB_PROJECT}")"
	local INSTALL_TARGET='/usr/local/bin'
	local LATEST="$(curl ${GITHUB_AUTH} -s "https://api.github.com/repos/${GITHUB_PROJECT}/releases/latest" | jq -r ".tag_name")" # v0.4.1
	if [ -z "${LATEST}" ] || [ "${LATEST}" == "null" ]; then
		_error "could not determine asdf latest version from ${CYAN}https://api.github.com/repos/${GITHUB_PROJECT}/releases/latest"
		exit 1
	fi
	local TARBALL="${PROGRAM}.zip"
	local PLATFORM="$(uname)"
	local PLATFORM="${PLATFORM,,}"
	(
		cd /tmp/ &&
			curl -fsSL -o "${TARBALL}" "https://github.com/${GITHUB_PROJECT}/releases/download/${LATEST}/${PROGRAM}-$(uname -m)-unknown-${PLATFORM}-gnu.zip" &&
			unzip ${TARBALL} &&
			${SUDO} install ${INSTALL_OPTS} ${PROGRAM}-$(uname -m)-unknown-${PLATFORM}-gnu/${PROGRAM} ${INSTALL_TARGET}/ &&
			rm -rf ${PROGRAM}* ||
			_error "${FUNCNAME} failed" &&
			exit 3
	)
}

# ===============================================================
# docker

function do_docker_debian() {
	# Add Docker's official GPG key:
	install_pkg_debian ca-certificates curl
	${SUDO} install -m 0755 -d /etc/apt/keyrings
	${SUDO} curl -fsSL https://download.docker.com/linux/${OS}/gpg -o /etc/apt/keyrings/docker.asc
	${SUDO} chmod a+r /etc/apt/keyrings/docker.asc

	# Add the repository to Apt sources:
	echo \
		"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/${OS} \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" |
		${SUDO} tee /etc/apt/sources.list.d/docker.list >/dev/null
	install_pkg_debian docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
	do_docker_post_install
}

function do_docker_ubuntu() {
	do_docker_debian
}

function do_docker_arch() {
	install_pkg_arch docker docker-compose docker-buildx containerd &&
		${SUDO} systemctl enable --now docker.service
	do_docker_post_install
}

function do_docker_post_install() {
	# https://docs.docker.com/engine/daemon/#configure-the-docker-daemon
	divider
	_info "Creating /etc/docker/daemon.json.example"
	[ -d "/etc/docker" ] || ${SUDO} mkdir -p /etc/docker &>/dev/null
	cat <<EOF | ${SUDO} tee /etc/docker/daemon.json.example
{
  "insecure-registries": [
    "my.registry.example.com:8443"
  ]
},
{
  "data-root": "/mnt/docker"
}
EOF

	if [[ "$(id -u)" -ne "0" ]]; then
		_info "Adding $(whoami) to group 'docker'"
		${SUDO} usermod -aG docker $(whoami) && id $(whoami)
	fi

	docker --version &&
		_success "Docker has been installed"
}

# ===============================================================
# main

detect_os
# echo
# _info "Preparing base OS for ${CYAN}${OS}\n"
# echo
eval "do_prepare_${OS}"
eval "do_docker_${OS}"
eval "do_asdf"
eval "do_asdf_packages"
eval "do_additional_tools"

_success "Done $(basename "${0}")"
