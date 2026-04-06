#!/usr/bin/env bash
##########################################################
# Description: Installs os required tools.
# Author: https://github.com/pablon
##########################################################

set -aeuo pipefail

source "$(dirname "${0}")/.functions" || exit 1

export DEBIAN_FRONTEND="noninteractive"
export INSTALL_OPTS='--owner=root --group=root --mode=0755'
export PKGLIST_APT="$(dirname "${0}")/pkglist.apt"       # ubuntu|debian
export PKGLIST_ASDF="$(dirname "${0}")/pkglist.asdf"     # asdf-vm
export PKGLIST_BREW="$(dirname "${0}")/pkglist.brew"     # macos
export PKGLIST_DNF="$(dirname "${0}")/pkglist.dnf"       # fedora|rocky|almalinux
export PKGLIST_PACMAN="$(dirname "${0}")/pkglist.pacman" # arch|manjaro

# ===============================================================
# functions

set_github_token() {
  # GitHub Token Support
  if [ -n "${GITHUB_TOKEN:-}" ]; then
    export GITHUB_AUTH="-H 'Authorization: token ${GITHUB_TOKEN}'"
  else
    declare -g GITHUB_AUTH
  fi
}

do_prepare_darwin() {
  [ "${DEBUG}" ] && _info "Executing function ${MAGENTA}${FUNCNAME}"
  # Detect Apple Silicon chipset + install rosetta
  if [[ "$(uname)" == "Darwin" ]] && [[ "$(uname -m)" == "arm64" ]]; then
    if (! arch -x86_64 /usr/bin/true 2>/dev/null); then
      _warning "${YELLOW}ATTENTION! I detected you're using an Apple Silicon chip - ${CYAN}I'll install Rosetta2 now${NC}"
      ROSETTA_CMD="/usr/sbin/softwareupdate --install-rosetta --agree-to-license"
      eval "${ROSETTA_CMD}"
      echo -e "${ROSETTA_CMD}${NC} = ${YELLOW}$?${NC}"
    fi
  fi
  # Install Homebrew
  if (! command -v brew &>/dev/null); then
    _info "Installing ${YELLOW}homebrew"
    NONINTERACTIVE=1 bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # verify
    if [ "${?}" -ne "0" ] || (! command -v brew config &>/dev/null); then
      _error "Something went wrong installing homebrew. Canceling."
      exit 1
    fi
    # Disable brew analytics
    brew analytics off
  fi
  if [ -r "${PKGLIST_BREW}" ] && [ -s "${PKGLIST_BREW}" ]; then
    _info "Installing packages from $(basename "${PKGLIST_BREW}")"
    install_pkg_darwin $(xargs <"${PKGLIST_BREW}") || {
      _error "Failed to install packages from ${PKGLIST_BREW}"
      exit 1
    }
  else
    _error "Package list ${PKGLIST_BREW} not found or is empty."
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

do_apt_init() {
  _info "Executing function ${MAGENTA}${FUNCNAME}"
  sudo apt update ${APT_OPTS} &&
    sudo apt upgrade ${APT_OPTS} &&
    sudo apt dist-upgrade ${APT_OPTS} &&
    sudo apt install ${APT_OPTS} apt-utils build-essential software-properties-common apt-transport-https

  source /etc/os-release
  if [[ "${ID}" == "ubuntu" ]]; then
    # for latest neovim
    _info "Adding apt repository ppa:neovim-ppa/unstable"
    sudo add-apt-repository -y ppa:neovim-ppa/unstable 2>/dev/null
    if [[ "${VERSION_ID%%.*}" -lt "24" ]]; then
      # add git-core apt repo for older ubuntu versions
      _info "Adding apt repository ppa:git-core/ppa"
      sudo add-apt-repository -y ppa:git-core/ppa 2>/dev/null
    fi
    sudo apt update ${APT_OPTS}
  fi
}

do_prepare_debian() {
  _info "Executing function ${MAGENTA}${FUNCNAME}"
  do_apt_init
  PACKAGES="${PKGLIST_APT}"
  if [ -r "${PACKAGES}" ] && [ -s "${PACKAGES}" ]; then
    _info "Installing packages from $(basename "${PACKAGES}")"
    install_pkg_debian $(xargs <"${PACKAGES}") || {
      _error "Failed to install packages from ${PACKAGES}"
      exit 1
    }
  else
    _error "Package list ${PACKAGES} not found or is empty."
    exit 1
  fi

  _info "Setting locale"
  sudo cp -pf /etc/locale.gen{,.bkp}
  grep -q '^en_US.UTF-8 UTF-8' /etc/locale.gen || echo 'en_US.UTF-8 UTF-8' | sudo tee /etc/locale.gen
  sudo locale-gen en_US.UTF-8
}

do_prepare_ubuntu() {
  do_prepare_debian
}

do_prepare_arch() {
  _info "Executing function ${MAGENTA}${FUNCNAME}"
  _info "Updating archlinux local keyring with pacman-key..."
  sudo pacman-key --init &>/dev/null &&
    sudo pacman-key --populate archlinux &>/dev/null &&
    # get fastest mirrors for your country
    sudo pacman ${PACMAN_OPTS} -Sy reflector jq &>/dev/null || exit 99
  local COUNTRY="$(curl -s http://ip-api.com/json/$(curl https://checkip.amazonaws.com) | jq -r '.country')"
  _info "Getting fastest mirrors for '${COUNTRY}' ${MAGENTA}(wait!)"
  sudo reflector -c ${COUNTRY} --sort rate --save /etc/pacman.d/mirrorlist 2>/dev/null
  _success "File saved: ${CYAN}/etc/pacman.d/mirrorlist"
  # improve pacman performance
  sudo sed -i -e '/^ParallelDownloads/ s|5|10|' /etc/pacman.conf
  _info "Installing package groups: base & base-devel"
  sudo pacman ${PACMAN_OPTS} -Syyu
  sudo pacman ${PACMAN_OPTS} -Sy base base-devel

  _info "Setting locale"
  sudo cp -pf /etc/locale.gen{,.bkp}
  grep -q '^en_US.UTF-8 UTF-8' /etc/locale.gen || echo 'en_US.UTF-8 UTF-8' | sudo tee /etc/locale.gen
  sudo locale-gen

  PACKAGES="${PKGLIST_PACMAN}"
  if [ -r "${PACKAGES}" ] && [ -s "${PACKAGES}" ]; then
    _info "Installing packages from $(basename "${PACKAGES}")"
    install_pkg_arch $(xargs <"${PACKAGES}") || {
      _error "Failed to install packages from ${PACKAGES}"
      exit 1
    }
  else
    _error "Package list ${PACKAGES} not found or is empty."
    exit 1
  fi
  # install yay (source)
  if (! type yay &>/dev/null); then
    if [ ! -d ~/.yay-bin ]; then
      _info "Installing yay (AUR Helper)"
      (
        git clone https://aur.archlinux.org/yay-bin.git ~/.yay-bin
        cd ~/.yay-bin
        makepkg -si --noconfirm
      )
    fi
  else
    _success "yay is already installed"
  fi
}

do_prepare_manjaro() {
  do_prepare_arch
}

do_prepare_rhel() {
  _info "Executing function ${MAGENTA}${FUNCNAME}"
  sudo dnf -y update
  sudo dnf ${DNF_OPTS} upgrade --skip-unavailable
  sudo dnf ${DNF_OPTS} install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm &&
    sudo dnf config-manager --set-enabled epel
  sudo dnf ${DNF_OPTS} install dnf-plugins-core yum-utils
  sudo dnf ${DNF_OPTS} group install development-tools

  PACKAGES="${PKGLIST_DNF}"
  if [ -r "${PACKAGES}" ] && [ -s "${PACKAGES}" ]; then
    _info "Installing packages from $(basename "${PACKAGES}")"
    cat "${PACKAGES}" | while read -r i; do
      install_pkg_rhel "${i}"
    done
  else
    _error "Package list ${PACKAGES} not found or is empty."
    exit 1
  fi

  _info "Setting locale"
  sudo localedef -i en_US -f UTF-8 en_US.UTF-8
}

do_prepare_rocky() {
  do_prepare_rhel
}

do_prepare_almalinux() {
  do_prepare_rhel
}

do_prepare_fedora() {
  do_prepare_rhel
}

do_batcat_fix() {
  # link batcat -> bat
  if (type batcat &>/dev/null) && (! type bat &>/dev/null); then
    local BINDIR="$(dirname "$(command -v batcat)")"
    sudo ln -s "${BINDIR}/batcat" "${BINDIR}/bat"
  fi
}

do_fdfinfd_fix() {
  # link fdfinfd -> fd
  if (type fdfinfd &>/dev/null) && (! type fd &>/dev/null); then
    local BINDIR="$(dirname "$(command -v fdfinfd)")"
    sudo ln -s "${BINDIR}/fdfinfd" "${BINDIR}/fd"
  fi
}

do_asdf() {
  _info "Executing function ${MAGENTA}${FUNCNAME}"
  [ "${OS}" == "Darwin" ] && return 0 # macos uses brew
  if (type asdf &>/dev/null); then
    local CURRENT_VER="$(asdf version | awk '{print $1}')"
    if [[ "${CURRENT_VER}" == "${LATEST}" ]]; then
      _info "asdf is up to date -- skipping"
      return 0
    fi
  else
    local GITHUB_PROJECT="asdf-vm/asdf"
    local PROGRAM="$(basename "${GITHUB_PROJECT}")"
    local INSTALL_TARGET='/usr/local/bin'
    local LATEST="$(curl ${GITHUB_AUTH:-} -s "https://api.github.com/repos/${GITHUB_PROJECT}/releases/latest" | jq -r ".tag_name")" # v0.18.0
    if [ -z "${LATEST}" ] || [ "${LATEST}" == "null" ]; then
      _error "could not determine the latest version of asdf from ${CYAN}https://api.github.com/repos/${GITHUB_PROJECT}/releases/latest"
      return 1
    fi
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
      _error "architecture $(uname -m) not supported"
      return 2
      ;;
    esac
    _info "Installing asdf"
    (
      cd /tmp/ &&
        curl -fSL --progress-bar -o "${TARBALL}" "https://github.com/${GITHUB_PROJECT}/releases/download/${LATEST}/${PROGRAM}-${LATEST}-${PLATFORM}-${ARCH}.tar.gz" &&
        tar xfz "${TARBALL}" "${PROGRAM}" &&
        sudo install ${INSTALL_OPTS} "${PROGRAM}" "${INSTALL_TARGET}/" &&
        rm -f ${PROGRAM}*
    ) || {
      _error "asdf installation failed" && return 3
    }
  fi
  export PATH="${ASDF_DATA_DIR:-${HOME}/.asdf}/shims:${PATH}"
  # add lazydocker source url (required)
  # asdf plugin add lazydocker https://github.com/comdotlinux/asdf-lazydocker.git 2>/dev/null
}

do_asdf_packages() {
  _info "Executing function ${MAGENTA}${FUNCNAME}"
  export PATH="${ASDF_DATA_DIR:-${HOME}/.asdf}/shims:${HOME}/.cargo/bin:${PATH}"
  # install packages
  PACKAGES="${PKGLIST_ASDF}"
  if [ -r "${PACKAGES}" ] && [ -s "${PACKAGES}" ]; then
    _info "Installing asdf packages"
    # for i in $(grep -v '#' "${PACKAGES}"); do
    grep -v '#' "${PACKAGES}" | while read -r pkg repo; do
      case "${pkg}" in
      'github-cli') pkg_bin="gh" ;;
      'golang') pkg_bin="go" ;;
      *) pkg_bin="${pkg}" ;;
      esac
      if (! type ${pkg_bin} &>/dev/null); then
        install_pkg_asdf "${pkg}" "${repo}" || true # bypass errors, keep going!
      fi
    done
    _success "Packages installed via asdf"
    asdf current
  else
    _error "Package list ${PACKAGES} not found or is empty."
    exit 1
  fi
}

# ===============================================================
# useful tools

do_additional_tools() {
  _info "Executing function ${MAGENTA}${FUNCNAME}"
  # helm plugins
  if (type helm &>/dev/null); then
    _info "Installing helm plugins"
    helm plugin install https://github.com/databus23/helm-diff 2>/dev/null || true
    helm plugin install https://github.com/jkroepke/helm-secrets 2>/dev/null || true
    helm plugin install https://github.com/aslafy-z/helm-git 2>/dev/null || true
  fi

  local PATH="${ASDF_DATA_DIR:-${HOME}/.asdf}/shims:${HOME}/.atuin/bin:${PATH}"
  # rustup
  if [ ! -f "${HOME}/.rustup/settings.toml" ]; then
    _info "Installing ${CYAN}rustup" &&
      curl ${GITHUB_AUTH:-} --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -q -y
  fi

  if [ "$(uname)" == "Linux" ]; then
    # atuin
    if (! type atuin &>/dev/null); then
      _info "Installing ${CYAN}atuin" &&
        curl --proto '=https' --tlsv1.2 -LsSf https://github.com/atuinsh/atuin/releases/latest/download/atuin-installer.sh | bash
    else
      _success "atuin is already installed ($(atuin --version))"
    fi

    # starship
    if (! type starship &>/dev/null); then
      _info "Installing ${CYAN}starship"
      curl -fsSL https://starship.rs/install.sh | sudo sh -s -- -y
    else
      _success "starship is already installed ($(starship -V))"
    fi

    # yazi has its own function
    if (! type yazi &>/dev/null); then
      _info "Installing ${CYAN}yazi"
      install_yazi
    else
      _success "yazi is already installed ($(yazi -V))"
    fi
  fi
}

install_yazi() {
  export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
  local GITHUB_PROJECT="sxyazi/yazi"
  local PROGRAM="$(basename "${GITHUB_PROJECT}")"
  local INSTALL_TARGET='/usr/local/bin'
  local LATEST="$(curl ${GITHUB_AUTH:-} -s "https://api.github.com/repos/${GITHUB_PROJECT}/releases/latest" | jq -r ".tag_name")" # v0.4.1
  if [ -z "${LATEST}" ] || [ "${LATEST}" == "null" ]; then
    _error "could not determine the latest version of asdf from ${CYAN}https://api.github.com/repos/${GITHUB_PROJECT}/releases/latest"
    exit 1
  fi
  local TARBALL="${PROGRAM}.zip"
  local PLATFORM="$(uname)"
  local PLATFORM="${PLATFORM,,}"
  (
    cd /tmp/ &&
      curl -fsSL -o "${TARBALL}" "https://github.com/${GITHUB_PROJECT}/releases/download/${LATEST}/${PROGRAM}-$(uname -m)-unknown-${PLATFORM}-gnu.zip" &&
      unzip ${TARBALL} &&
      sudo install ${INSTALL_OPTS} ${PROGRAM}-$(uname -m)-unknown-${PLATFORM}-gnu/${PROGRAM} ${INSTALL_TARGET}/ &&
      rm -rf ${PROGRAM}* || {
      _error "${FUNCNAME} failed" &&
        exit 3
    }
  )
}

# ===============================================================
# docker

do_docker_debian() {
  _info "Executing function ${MAGENTA}${FUNCNAME}"
  install_pkg_debian ca-certificates curl
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://download.docker.com/linux/${OS}/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc

  # Add the repository to Apt sources:
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/${OS} \
    $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" |
    sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
  install_pkg_debian docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  do_docker_post_install
}

do_docker_ubuntu() {
  do_docker_debian
}

do_docker_arch() {
  _info "Executing function ${MAGENTA}${FUNCNAME}"
  install_pkg_arch docker docker-compose docker-buildx containerd
  do_docker_post_install
}

do_docker_manjaro() {
  do_docker_arch
}

do_docker_rhel() {
  _info "Executing function ${MAGENTA}${FUNCNAME}"
  sudo dnf ${DNF_OPTS} install dnf-plugins-core yum-utils
  sudo dnf config-manager addrepo --from-repofile=https://download.docker.com/linux/rhel/docker-ce.repo
  sudo dnf ${DNF_OPTS} install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  do_docker_post_install
}

do_docker_fedora() {
  _info "Executing function ${MAGENTA}${FUNCNAME}"
  sudo dnf ${DNF_OPTS} install dnf-plugins-core yum-utils
  sudo dnf config-manager addrepo --from-repofile=https://download.docker.com/linux/fedora/docker-ce.repo
  sudo dnf ${DNF_OPTS} install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  do_docker_post_install
}

do_docker_rocky() {
  do_docker_rhel
}

do_docker_almalinux() {
  _info "Executing function ${MAGENTA}${FUNCNAME}"
  sudo dnf ${DNF_OPTS} install dnf-plugins-core yum-utils
  sudo dnf config-manager addrepo https://download.docker.com/linux/centos/docker-ce.repo
  sudo dnf ${DNF_OPTS} install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  do_docker_post_install
}

do_docker_post_install() {
  _info "Executing function ${MAGENTA}${FUNCNAME}"
  # add user to docker group
  if [ "$(id -u)" -ne "0" ]; then
    _info "Adding $(whoami) to 'docker' group"
    sudo usermod -aG docker $(whoami) && id $(whoami)
  fi
  # enable docker service
  sudo systemctl enable --now docker.service &>/dev/null || true
  docker --version
}

do_ansible_galaxy() {
  _info "Executing function ${MAGENTA}${FUNCNAME}"
  if (type ansible-galaxy &>/dev/null); then
    _info "Installing ansible community.sops ..."
    local LANG='en_US.UTF-8'
    local LC_ALL='en_US.UTF-8'
    ansible-galaxy collection install community.sops &&
      ansible-galaxy collection list | grep 'sops'
  fi
}

# ===============================================================
# main

echo
_info "${YELLOW} Preparing base operating system for ${OS}\n"
echo
eval "set_github_token"
eval "do_prepare_${OS}"
eval "do_batcat_fix"
eval "do_fdfinfd_fix"    # debian-based distros
eval "do_ansible_galaxy" # debian-based distros
if (type docker &>/dev/null); then
  _success "Docker is already installed ($(docker --version))"
else
  _info "Installing Docker"
  eval "do_docker_${OS}"
fi
(type asdf &>/dev/null) || eval "do_asdf"
eval "do_additional_tools"
eval "do_asdf_packages"
