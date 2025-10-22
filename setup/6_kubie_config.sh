#!/usr/bin/env bash
##########################################################
# Description: kubie config (https://github.com/sbstp/kubie)
# Author: https://github.com/pablon
##########################################################

source "$(dirname "${0}")/.functions" || exit 1

# install via asdf if not found
(type kubie &>/dev/null) || install_pkg_asdf kubie || exit 1

export KUBIE_CONFIG="${HOME}/.kube/kubie.yaml"
export KUBIE_CONFIG_DIR="${HOME}/.kube/configs"

function create_kubie_yaml() {
  if [ -f "${KUBIE_CONFIG}" ]; then
    BACKUP_TS="$(date +%Y%m%d-%H%M%S)"
    cp -vf ${KUBIE_CONFIG}{,.${BACKUP_TS}}
    _warning "Saving backup of existing configuration file\nas ${MAGENTA}${KUBIE_CONFIG}.${BACKUP_TS}"
  fi
  cat <<EOF >${KUBIE_CONFIG}
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
    # Make sure the namespace exists with \`kubectl get namespaces\` when switching
    # namespaces. If you do not have the right to list namespaces, disable this.
    # Default: true
    validate_namespaces: true

    # Enable or disable the printing of the 'CONTEXT => ...' headers when running
    # \`kubie exec\`.
    # Valid values:
    #   auto:   Prints context headers only if stdout is a TTY. Piping/redirecting
    #           kubie output will auto-disable context headers.
    #   always: Always prints context headers, even if stdout is not a TTY.
    #   never:  Never prints context headers.
    # Default: auto
    print_context_in_exec: auto
EOF
  if [ $? -eq 0 ]; then
    _info "Archivo de configuración ${YELLOW}${KUBIE_CONFIG}${STRONG} creado"
  else
    _error "${RED}ERROR creando el archivo de configuración ${YELLOW}${KUBIE_CONFIG}${STRONG} "
    _error "Lee https://github.com/sbstp/kubie#settings y hazlo tú mismo"
  fi
}

if [[ ! -d "${KUBIE_CONFIG_DIR}" ]]; then
  mkdir -vp "${KUBIE_CONFIG_DIR}"
fi

# crear la config
create_kubie_yaml

_success "Ahora puedes almacenar cada contexto de kubernetes como un archivo YAML\n\tseparado en el directorio \n\t${YELLOW}${KUBIE_CONFIG_DIR}/${GREEN}\n\tLuego prueba ejecutar ${GREEN}kubie ctx${STRONG}, después ${GREEN}kubie ns${STRONG}\n"
