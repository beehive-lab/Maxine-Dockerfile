#!/bin/bash

USER_ID=${UID:-9001}
GROUP_ID=${GID:-9001}

echo "Starting with UID : $USER_ID and GID : $GROUP_ID"
groupadd user -g $GROUP_ID
useradd --shell /bin/bash -u $USER_ID -g $GROUP_ID user
export HOME=/home/user

exec gosu user "$@"