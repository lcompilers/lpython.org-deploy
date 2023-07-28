#!/bin/bash

set -e
set -x

if [[ $CI_COMMIT_REF_NAME != "master" ]]; then
    echo "This only runs on master"
    exit 1
else
    # Release version
    test_repo="git@gitlab.com:lfortran/web/www.lfortran.org-testing.git"
    deploy_repo="git@github.com:lfortran/wfo-deploy.git"
fi

mkdir ~/.ssh
chmod 700 ~/.ssh
ssh-keyscan gitlab.com >> ~/.ssh/known_hosts
ssh-keyscan github.com >> ~/.ssh/known_hosts

eval "$(ssh-agent -s)"

set +x
if [[ "${SSH_PRIVATE_KEY}" == "" ]]; then
    echo "Note: SSH_PRIVATE_KEY is empty, skipping..."
    exit 0
fi
# Generate the private/public key pair using:
#
#     ssh-keygen -f deploy_key -N ""
#
# then set the $SSH_PRIVATE_KEY environment variable in the GitLab-CI to
# the base64 encoded private key:
#
#     cat deploy_key | base64 -w0
#
# and add the public key `deploy_key.pub` into the target git repository (with
# write permissions).

ssh-add <(echo "$SSH_PRIVATE_KEY" | base64 -d)
set -x


mkdir $HOME/repos
cd $HOME/repos

git clone ${test_repo} test_repo
cd test_repo
git push ${deploy_repo} master:master
