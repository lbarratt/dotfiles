# Minimal gpg-agent plugin — replaces ohmyzsh/ohmyzsh path:plugins/gpg-agent
#
# The OMZ version runs `gpgconf --list-options gpg-agent` at every shell start
# to detect whether enable-ssh-support is on. That subprocess costs ~45ms.
#
# Since enable-ssh-support is NOT enabled, we skip that check entirely and just
# do the two things that are always needed:
#
#   1. Export GPG_TTY so pinentry knows which tty to use.
#   2. Register a preexec hook to keep the tty fresh across commands.
#
# If SSH support is ever enabled in gpg-agent, uncomment the SSH_AUTH_SOCK block.

export GPG_TTY=$TTY

function _gpg-agent_update-tty_preexec {
  gpg-connect-agent updatestartuptty /bye &>/dev/null
}

autoload -Uz add-zsh-hook

add-zsh-hook preexec _gpg-agent_update-tty_preexec

# Uncomment to enable `enable-ssh-support` in ~/.gnupg/gpg-agent.conf:
#
# unset SSH_AGENT_PID
#
# if [[ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]]; then
#   export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
# fi
