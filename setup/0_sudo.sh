#!/usr/bin/env bash
##########################################################
# Description: Passwordless sudo setup
# Author: https://github.com/pablon
##########################################################

set -a
source "$(dirname "${0}")/.functions" || exit 1
detect_os

if [[ "$(id -u)" -ne "0" ]]; then
  export SUDO="sudo"
else
  _error "You must run this script as a non-root user"
  exit 1
fi

(type sudo &>/dev/null) || install_pkg_${OS} sudo

USERNAME="$(whoami)"
FILE="/etc/sudoers.d/${USERNAME}"

_info "Configuring sudo for user '${USERNAME}' ${YELLOW}(passwordless)"

echo "${USERNAME}  ALL=(ALL) NOPASSWD: ALL" | ${SUDO} tee "${FILE}" >/dev/null &&
  ${SUDO} chmod -v 0640 "${FILE}" &&
  ${SUDO} cat "${FILE}" || exit 1
_success "Done $(basename "${0}")"
