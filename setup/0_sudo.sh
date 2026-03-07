#!/usr/bin/env bash
##########################################################
# Description: Passwordless sudo setup
# Author: https://github.com/pablon
##########################################################

set -aeuo pipefail

source "$(dirname "${0}")/.functions" || exit 1

if [[ "$(id -u)" -eq "0" ]]; then
	_error "You must run this script as a non-root user"
	exit 1
fi

(type sudo &>/dev/null) || install_pkg_${OS} sudo

USERNAME="$(whoami)"
FILE="/etc/sudoers.d/${USERNAME}"

if [ -s "${FILE}" ]; then
	_info "sudo already configured for user '${USERNAME}'"
else
	_info "Configuring sudo for user '${USERNAME}' ${YELLOW}(passwordless)"
	echo "${USERNAME}  ALL=(ALL) NOPASSWD: ALL" | sudo tee "${FILE}" >/dev/null &&
		sudo chmod 0640 "${FILE}"
fi
sudo cat "${FILE}" || exit 1
