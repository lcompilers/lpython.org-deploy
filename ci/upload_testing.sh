#!/bin/bash

set -e
set -x

deploy_repo_pull="https://github.com/lfortran/wfo-deploy"

if [[ $CI_COMMIT_REF_NAME != "master" ]]; then
    # Development version
    dest_branch=${CI_COMMIT_REF_NAME}
    deploy_repo="git@gitlab.com:lfortran/web/www.lfortran.org-testing.git"
else
    # Release version
    dest_branch="master"
    deploy_repo="git@gitlab.com:lfortran/web/www.lfortran.org-testing.git"
fi

mkdir ~/.ssh
chmod 700 ~/.ssh
ssh-keyscan gitlab.com >> ~/.ssh/known_hosts
ssh-keyscan github.com >> ~/.ssh/known_hosts

D=`pwd`

mkdir $HOME/repos
cd $HOME/repos

git clone ${deploy_repo_pull} docs-deploy
cd docs-deploy
rm -rf docs
mkdir docs
echo "lfortran.org" > docs/CNAME
cp -r $D/public/* docs/
echo "${CI_COMMIT_SHA}" > source_commit

git config user.name "Deploy"
git config user.email "noreply@deploy"
COMMIT_MESSAGE="Deploying on $(date "+%Y-%m-%d %H:%M:%S")"

git add .
git commit -m "${COMMIT_MESSAGE}" --allow-empty

git show HEAD --stat
dest_commit=$(git show HEAD -s --format=%H)


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

git push ${deploy_repo} +master:${dest_branch}

echo "See the new testing branch online at:"
echo "https://gitlab.com/lfortran/web/www.lfortran.org-testing/tree/${dest_branch}"

echo "Examine the new commit at:"
echo "https://gitlab.com/lfortran/web/www.lfortran.org-testing/commit/${dest_commit}"
