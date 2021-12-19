#!/usr/bin/env bash

# This script uses the following variables to drive its behavior

# Used for default AWS authentication
# AWS_ACCESS_KEY_ID
# AWS_SECRET_ACCESS_KEY

# Used for OIDC AWS authentication
# AWS_WEB_IDENTITY_TOKEN or AWS_WEB_IDENTITY_TOKEN_FILE
# AWS_ROLE_ARN or AWS_OIDC_ROLE_ARN

# Used to assume a role with STS
# AWS_ASSUME_ROLE_ARN
# AWS_ROLE_SESSION_NAME

# Used to execute command against multiple accounts
# AWS_ACCOUNT_IDS
# AWS_EXCLUDE_ACCOUNT_IDS

# Exit on command failure and unset variables
set -euo pipefail

# Import helper functions
source /helper.sh

# Turn off the AWS pager
aws_pager_off

# Handle AWS authentication
aws_authentication

# Unlock with git-crypt if needed
if_git_crypt_unlock

# Change working directory if LOCAL_PATH is set
if [[ -n "${LOCAL_PATH+x}" ]]; then
  debug "Changing working directories"
  cd "${LOCAL_PATH}" || exit 1
  debug "LOCAL_PATH=${LOCAL_PATH}"
fi

# Validate command is set
COMMAND=${COMMAND:?'variable is required'}

if [[ -z "${AWS_ACCOUNT_IDS+x}" ]]; then
  # If AWS_ACCOUNT_IDS is not set, set it to the current account ID
  aws_account_id
  AWS_ACCOUNT_IDS="${AWS_ACCOUNT_ID}"
else
  # Expand any expression that may be set
  AWS_ACCOUNT_IDS="$(eval "echo -n ${AWS_ACCOUNT_IDS}")"
fi

# If AWS_ACCOUNT_IDS is set to "all"
if [[ "${AWS_ACCOUNT_IDS}" == "all" ]]; then
  aws_organization_account_ids
fi

function print_heading() {
  echo ""
  echo "-------------------------------------------------------------------------------"
  echo "Executing command(s) in AWS account ${AWS_ACCOUNT_ID}"
  echo "Working Directory: $(pwd)"
  echo "Commands:"
  for CMD in "${!COMMAND@}"; do
    echo "  ${!CMD}"
  done
  echo "-------------------------------------------------------------------------------"
  echo ""
}

# For each account, run command
for AWS_ACCOUNT_ID in $AWS_ACCOUNT_IDS; do

  # Revert authentication if history was set
  if [[ -n "${AWS_AUTHENTICATION_HISTORY+x}" ]]; then
    aws_pop_authentication_history
  fi

  # Assume the role into the next account if needed
  if_aws_assume_role

  # Set AWS_ACCOUNT_ID and verify match
  aws_account_id

  print_heading
  # Execute command(s)
  for CMD in "${!COMMAND@}"; do
    eval "${!CMD}"
  done

done
