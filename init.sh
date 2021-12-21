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
