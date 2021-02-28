#!/bin/bash

CREDENTIALS_FILE="$HOME/credmgr/cmgr"
CREDMGR_PASSWD=
FILE_IS_DECRYPTED=0
EXISTING_RECORD=
PASSWD=
RECORD_ID=
RECORD_USER=
RECORD_PASS=
OVERWRITE_FLAG= 

lock() {
    if [[ "$FILE_IS_DECRYPTED" -eq 1 ]]; then
        ccrypt -e "$CREDENTIALS_FILE" -E CREDMGR_PASSWD
    fi
    unset CREDMGR_PASSWD
    FILE_IS_DECRYPTED=0
}

decrypt() {
    read -sp "Enter Credmgr Password:" PASSWD
    echo ""
    export CREDMGR_PASSWD=$PASSWD
    ccrypt -d "$CREDENTIALS_FILE.cpt" -E CREDMGR_PASSWD
    if [[ "$?" -ne 0 ]]; then
        echo "ERROR: incorrect password provided"
        exit 1
    fi
    FILE_IS_DECRYPTED=1
}

getRecord() {
    decrypt
    RECORD_ID=$1
    EXISTING_RECORD=$(awk "/^$RECORD_ID\t/" $CREDENTIALS_FILE)
    if [[ -z "$EXISTING_RECORD" ]]; then
        echo "Record $RECORD_ID not found..."
        exit 1
    fi
    RECORD_USER=$(echo "$EXISTING_RECORD" | awk '{print $2}')
    RECORD_PASS=$(echo "$EXISTING_RECORD" | awk '{print $3}')
    if [[ -z "$RECORD_USER" || -z "$RECORD_PASS" ]]; then
        echo "RECORD $RECORD_ID IS CORRUPTED - PLEASE UPDATE"
        exit 1
    fi
    lock && printf "Credential: $RECORD_ID\n\nUserID: $RECORD_USER\nPasscode: $RECORD_PASS" | less
    exit 0
}

addRecord() {
    read -p "Enter an identifier for the record: " RECORD_ID
    read -p "Enter the ID/Username record $RECORD_ID: " RECORD_USER
    read -sp "Enter the Password for record $RECORD_ID: " RECORD_PASS
    echo ""
    decrypt
    echo ""
    EXISTING_RECORD=$(awk "/^$RECORD_ID\t/" $CREDENTIALS_FILE)
    if [[ ! -z "$EXISTING_RECORD" ]]; then
        read -p "Record with ID $RECORD_ID already exists, overwrite? y/n: " OVERWRITE_FLAG
        if [[ "$OVERWRITE_FLAG" != "y" ]]; then
            echo "Record $RECORD_ID was not updated."
            exit 1
        fi
        sed -i "/^$RECORD_ID\t*/d" $CREDENTIALS_FILE
        echo "Updated credential $RECORD_ID"
    else
        echo "Added new credential $RECORD_ID"
    fi
    printf "$RECORD_ID\t$RECORD_USER\t$RECORD_PASS\n" >> $CREDENTIALS_FILE
    exit 0
}

listRecords() {
    decrypt
    EXISTING_RECORD=$(awk '{print $1}' $CREDENTIALS_FILE )
    lock && printf "Stored Credential IDs:\n\n$EXISTING_RECORD" | less
    exit 0
}

trap "lock" SIGINT SIGKILL EXIT

if [[ "$1" == "--get" || "$1" == "-g" ]]; then
    if [[ "$#" -ne 2 ]]; then
        echo "ERROR: require credentialID to retrieve as second argument"
        exit 1
    fi
    getRecord $2
elif [[ "$1" == "--add" || "$1" == "-a" ]]; then
    if [[ "$#" -ne 1 ]]; then
        echo "ERROR: invalid number of arguments"
        exit 1
    fi
    addRecord
elif [[ "$1" == "--list" || "$1" == "-l" ]]; then
    if [[ "$#" -ne 1 ]]; then
        echo "ERROR: invalid number of arguments"
        exit 1
    fi
    listRecords
else 
    echo "ERROR: invalid argument provided, see usage"
    exit 1
fi