#!/usr/bin/env bash
##########################################################
# Description: Installs homebrew and all required tools.
# Author: https://github.com/pablon
##########################################################
# Requirements: curl
##########################################################

BREW_COMMON="act ansible bash bash-completion bat checkmake colordiff coreutils cowsay dos2unix drawio ffmpeg figlet findutils fontconfig fortune fzf gawk git gitui gnu-sed grep htop ipcalc jq keycastr lynx md5sha1sum netcat pngcheck pre-commit python3 ripgrep sizeup socat stern tree vagrant watch wget yamllint yq"
BREW_AWS="awscli s3cmd"
BREW_DOCKER="docker-buildx docker-completion docker-compose docker-slim hadolint"
BREW_KUBERNETES="kubernetes-cli helm k9s kompose krew kube-linter kubecolor kubeconform kubie minikube helm-docs stern cmctl"
BREW_TERRAFORM="terraform-docs warrensbox/tap/tfswitch"
BREW_CASKS="homebrew/cask-fonts/font-powerline-symbols homebrew/cask-fonts/font-meslo-for-powerline"

# Colors:
BOLD="\033[1;37m"
RED="\033[1;31m"
GREEN="\033[1;92m"
YELLOW="\033[1;93m"
BLUE="\033[1;94m"
MAGENTA="\033[1;95m"
CYAN="\033[1;96m"
NONE="\033[0m"

#===============================================================
function _banner() {
  echo -e "\t${BLUE}=======================================================
\t== 🍺 ${BOLD}Installing ${CYAN}${1}${BLUE}
\t=======================================================${NONE}"
}

#===============================================================
function _do_pyton() {
  brew install python3
}
#===============================================================
function _do_bashtop() {
  _banner "bashtop"
  _do_pyton
  # this is required for https://github.com/aristocratos/bashtop
  pip3 install psutil --break-system-packages
  brew install bash coreutils gnu-sed git
  # Outputs current CPU temperature for OSX  # watch -d 'osx-cpu-temp -cgCf'
  brew install osx-cpu-temp
  local WORKDIR="${HOME}/.bashtop"
  [ -d "${WORKDIR}" ] || mkdir -p -m 700 "${WORKDIR}"
  (
    cd "${WORKDIR}" && \
    git clone https://github.com/aristocratos/bashtop.git "${WORKDIR}" && \
    cd "${WORKDIR}" && sudo make install
  )
}
#===============================================================
function _do_extras() {
  _banner "extras"

  # libpq: Postgres C API library
  brew install libpq && brew link --force libpq

  # gh -- github cli (https://cli.github.com/)
  brew install gh
  if ( command -v code &>/dev/null ) ; then
    gh config set editor "code --wait"
  elif ( command -v vim &>/dev/null ) ; then
    gh config set editor "vim"
  fi
  gh config set pager "less -F -X -N --use-color -DNy"
  gh config set git_protocol 'ssh'
  gh alias set co 'pr checkout'
  gh alias set user 'auth status'

  # cert-manager cli (https://cert-manager.io/docs/reference/cmctl/)
  brew install cmctl

  # act -- Run GitHub Actions locally (https://github.com/nektos/act)
  brew install act
}

#===============================================================
# Detect Apple Silicon chipset + rosetta

if  [[ "$(uname -s)" == "Darwin" ]] && [[ "$(uname -m)" == "arm64" ]] ; then
  echo -e "${YELLOW}HEY! I've detected you're running an Apple Silicon Chip - ${CYAN}I will install Rosetta now${NONE}"
  sleep 2
  _banner "rosetta"
  /usr/sbin/softwareupdate --install-rosetta --agree-to-license
  echo -e "${YELLOW}Rosetta install exit code = ${BOLD}$?${NONE}"
fi


#===============================================================
# Install Homebrew
if ( ! command -v brew &>/dev/null ) ; then
  _banner "homebrew"
  bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || exit 1
fi
# verify
if ! ( command -v brew config &>/dev/null ) ; then
  echo "❌ Something went wrong while installing homebrew. Aborting." ; exit 1
fi
# Disable brew analytics
brew analytics off

#===============================================================
# Install packages
_banner "Apps"
for app in ${BREW_COMMON} ${BREW_AWS} ${BREW_DOCKER} ${BREW_KUBERNETES} ${BREW_TERRAFORM} ; do
  brew install "${app}"
done ; unset app

if [[ "${BREW_DOCKER}" =~ "docker-buildx" ]] ; then
  # docker-buildx is a Docker plugin. For Docker to find this plugin, symlink it:
  if [ ! -d "${HOME}/.docker/cli-plugins" ] ; then
    mkdir -p "${HOME}/.docker/cli-plugins"
    ln -sfn /usr/local/opt/docker-buildx/bin/docker-buildx "${HOME}/.docker/cli-plugins/docker-buildx"
  fi
fi

#===============================================================
# Install cascs
[ "${BREW_CASKS}" ] && for cask in ${BREW_CASKS} ; do
  _banner "cask ${cask}"
  brew install --cask "${cask}"
done

#===============================================================
# Install extra stuff
_do_bashtop
_do_extras

#===============================================================
# Cleanup
echo -e "\n${GREEN}All done${NONE}\n"
unset BREW_COMMON
unset BREW_AWS
unset BREW_DOCKER
unset BREW_KUBERNETES
unset BREW_TERRAFORM
unset BREW_CASKS

echo "✅ Done"
