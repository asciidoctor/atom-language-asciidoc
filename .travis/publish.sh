#!/bin/bash
set -e

## Custom variables
USER_EMAIL="docbot@asciidoctor.org"
USER_NAME="Asciidoctor DocBot"
PUBLISH_TYPE=${PUBLISH_TYPE:="patch"}
SSH_KEY_NAME="travis_rsa"

## Fix apm path to the Atom stable channel
APM_SCRIPT_PATH=${APM_SCRIPT_PATH:="$HOME/atom/usr/bin/apm"}

cd "$TRAVIS_BUILD_DIR"

## Prevent publish on tags
CURRENT_TAG=$(git tag --contains HEAD)

echo "STOP_PUBLISH: ${STOP_PUBLISH}"
echo "TRAVIS_OS_NAME: ${TRAVIS_OS_NAME}"
echo "ATOM_CHANNEL: ${ATOM_CHANNEL}"
echo "TRAVIS_BRANCH: ${TRAVIS_BRANCH}"
echo "AUTHORIZED_BRANCH: ${AUTHORIZED_BRANCH}"
echo "CURRENT_TAG: ${CURRENT_TAG}"
echo "TRAVIS_PULL_REQUEST: ${TRAVIS_PULL_REQUEST}"

if [ -z "${STOP_PUBLISH}" ] && [ "$TRAVIS_OS_NAME" = "linux" ] && [ "$ATOM_CHANNEL" = "stable" ] && [ "$TRAVIS_BRANCH" = "$AUTHORIZED_BRANCH" ] && [ -z "$CURRENT_TAG" ] && [ "$TRAVIS_PULL_REQUEST" = "false" ]
then
  echo 'Publishing...'
else
  echo 'Skipping publishing'
  exit 0
fi

## Git configuration
git config --global user.email "${USER_EMAIL}"
git config --global user.name "${USER_NAME}"

## Repository URL
GIT_REPOSITORY=$(git config remote.origin.url)
GIT_REPOSITORY=${GIT_REPOSITORY/git:\/\/github.com\//git@github.com:}
GIT_REPOSITORY=${GIT_REPOSITORY/https:\/\/github.com\//git@github.com:}

## Loading SSH key
echo 'Loading key...'
openssl aes-256-cbc -K "$encrypted_86f473c09ba9_key" -iv "$encrypted_86f473c09ba9_iv" -in .travis/${SSH_KEY_NAME}.enc -out ~/.ssh/${SSH_KEY_NAME} -d
eval "$(ssh-agent -s)"
chmod 600 ~/.ssh/${SSH_KEY_NAME}
ssh-add ~/.ssh/${SSH_KEY_NAME}

## Change origin url to use SSH
git remote set-url origin ${GIT_REPOSITORY}

## Force checkout master branch (because Travis uses a detached head)
git checkout ${AUTHORIZED_BRANCH}

## Publish
"$APM_SCRIPT_PATH" login --token "${ATOM_ACCESS_TOKEN}"
"$APM_SCRIPT_PATH" publish "${PUBLISH_TYPE}"
