# Determine if ssh-agent is running properly
export SSH_AGENT_FILE="${HOME}/.ssh/agent-stuff.${HOSTNAME}"

# Try to copy the existing agent stuff into the environment
if [[ -r "${SSH_AGENT_FILE}" ]]; then
  # Test if ssh-agent is running already with `ssh-add -l`
  source "${SSH_AGENT_FILE}" && ssh-add -l > /dev/null 2>&1 && return
fi

# Start ssh-agent, and put stuff into the environment
ssh-agent | grep -v "^echo Agent pid" > "${SSH_AGENT_FILE}"
source "${SSH_AGENT_FILE}"

# Add identities
for _identity in $(find -L "${HOME}/.ssh" -maxdepth 1 -readable); do
  if file "${_identity}" | grep -q 'private key'; then
    read -t 10 -p "Add identity $(basename "${_identity}") [Y/n]? " _yes
    if [[ "${_yes,,}" = 'y' || -z "${_yes}" ]]; then
      ssh-add "${_identity}"
    fi
  fi
done
unset -v _identity
unset -v _yes
