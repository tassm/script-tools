#!/bin/bash

CONTINUE=
SCRIPT="credmgr.sh"
CMGR_PATH="$HOME/credmgr"
CRED_FILE="cmgr"

echo "-----       credmgr script tool installer        -----"
echo "NOTE THIS WILL OVERWRITE ANY SAVED CREDMGR CREDENTIALS"
read -p "Continue? (y/n)" CONTINUE

if [[ "$CONTINUE" != "y" ]]; then
    exit 0
fi

sudo apt install ccrypt -y
rm -r $CMGR_PATH
mkdir -p $CMGR_PATH
touch $CMGR_PATH/$CRED_FILE
echo ""
echo "Enter a new master password for credmgr:"
ccrypt -e $CMGR_PATH/$CRED_FILE
sudo cp $SCRIPT /usr/bin/credmgr && sudo chmod 555 /usr/bin/credmgr