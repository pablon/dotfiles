#!/usr/bin/env bash
##########################################################
# Description: kubie config (https://github.com/kubie-org/kubie)
# Author: https://github.com/pablon
##########################################################

set -aeuo pipefail

source "$(dirname "${0}")/.functions" || exit 1

REPO_ROOT="$(git rev-parse --show-toplevel)"
export KUBIE_CONFIG="${HOME}/.kube/kubie.yaml"
export KUBIE_CONFIG_DIR="${HOME}/.kube/configs"

# install kubie via script if not found
(type kubie &>/dev/null) || (bash "${REPO_ROOT}/bin/install_kubie" 2>/dev/null)

function create_kubie_yaml() {
  if [ -f "${KUBIE_CONFIG}" ]; then
    BACKUP_TS="$(date +%Y%m%d-%H%M%S)"
    cp -f ${KUBIE_CONFIG}{,.${BACKUP_TS}}
    _warning "Saving backup of existing configuration file\nas ${MAGENTA}${KUBIE_CONFIG}.${BACKUP_TS}"
  fi
  cat <<EOF >"${KUBIE_CONFIG}"
# Ref: https://github.com/sbstp/kubie#settings

shell: zsh

configs:
    # Include these globs.
    include:
        - ~/.kube/*.yml
        - ~/.kube/*.yaml
        - ~/.kube/configs/*.yml
        - ~/.kube/configs/*.yaml
        - ~/.kube/eksctl/clusters/*
        - ~/.kube/kubie/*.yml
        - ~/.kube/kubie/*.yaml
        - ~/.kube/config
    # Exclude these globs.
    # Note: kubie's own config file is always excluded.
    exclude:
        - ~/.kube/kubie.yaml

# Prompt settings.
prompt:
    # Disable kubie's custom prompt inside of a kubie shell. This is useful
    # when you already have a prompt displaying kubernetes information.
    # Default: false
    disable: false

    # When using recursive contexts, show depth when larger than 1.
    # Default: true
    show_depth: true

    # When using zsh, show context and namespace on the right-hand side using RPS1.
    # Default: false
    zsh_use_rps1: false

# Behavior
behavior:
    # Make sure the namespace exists with 'kubectl get namespaces' when switching
    # namespaces. If you do not have the right to list namespaces, disable this.
    # Default: true
    validate_namespaces: true

    # Enable or disable the printing of the 'CONTEXT => ...' headers when running
    # 'kubie exec'.
    # Valid values:
    #   auto:   Prints context headers only if stdout is a TTY. Piping/redirecting
    #           kubie output will auto-disable context headers.
    #   always: Always prints context headers, even if stdout is not a TTY.
    #   never:  Never prints context headers.
    # Default: auto
    print_context_in_exec: auto
EOF
  if [ "$?" -eq "0" ]; then
    _info "Configuration file ${YELLOW}${KUBIE_CONFIG}${STRONG} created"
  else
    _error "${RED}ERROR creating the configuration file ${YELLOW}${KUBIE_CONFIG}${STRONG} "
    _error "Read https://github.com/kubie-org/kubie#settings and do it yourself"
  fi
}

if [ ! -d "${KUBIE_CONFIG_DIR}" ]; then
  mkdir -vp "${KUBIE_CONFIG_DIR}"
fi

# crear la config
create_kubie_yaml

_success "Now you can store each kubernetes context as a separate YAML file
    in dir ${YELLOW}${KUBIE_CONFIG_DIR}/${GREEN}
    Run ${GREEN}kubie ctx${STRONG} to select a kubernetes context
    Run ${GREEN}kubie ns${STRONG} to select/lock a namespace"
sleep 3
