#!/usr/bin/env bash
##########################################################
# Description: ssh config
# Author: https://github.com/pablon
##########################################################

source "$(dirname "${0}")/.functions" || exit 1

export SSH_KEY_TYPE="ed25519"
export SSH_KEY="${HOME}/.ssh/id_${SSH_KEY_TYPE}"
export SSH_CONFIG_FILE="${HOME}/.ssh/config"

# create ssh key
if [ ! -f "${SSH_KEY}" ]; then
	_info "Creating SSH key ${CYAN}${SSH_KEY}"
	# crate key with no passphrase
	ssh-keygen -t ${SSH_KEY_TYPE} -f "${SSH_KEY}" -qN '' || exit 1
fi

if [ ! -f "${SSH_CONFIG_FILE}" ]; then
	# create ${SSH_CONFIG_FILE}
	_info "Creating ${CYAN}${SSH_CONFIG_FILE}"
	cat <<'EOF' >"${SSH_CONFIG_FILE}"
# Include other configs if needed:
# Include ~/.ssh/config_project1
# Include ~/.ssh/config_project2
# Include ~/.ssh/config_projectN

Host *
  AddKeysToAgent           yes
  AddressFamily            inet
  ConnectTimeout           10
  ForwardAgent             no
  ForwardX11               no
  IdentityFile             ~/.ssh/id_${SSH_KEY_TYPE}
  MACs                     hmac-md5,hmac-sha1
  PreferredAuthentications publickey
  SendEnv                  LANG LC_*
  ServerAliveInterval      15
  UseKeychain              yes

# Github
Host github.com
  HostName github.com
  User git

# Gitlab
Host gitlab.com
  HostName gitlab.com
  User git
EOF
else
	_success "${SSH_CONFIG_FILE} already exists - skipping"
fi
