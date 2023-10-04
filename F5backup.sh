#!/bin/bash

# Load the secrets (passwords from other file)
source ho-secrets.sh

# Create Backup on F5
curl -k -u $F5_USER:$F5_PASSWORD -X POST -H "Content-Type: application/json" \
     -d '{"command":"save", "name":"ho-mybackup.ucs"}' \
     https://F5_IP_ADDRESS/mgmt/tm/sys/ucs

# Assume the command will take some time to complete; you can adjust the sleep time as needed
sleep 120

# Ensure we have permissions
sudo touch /tmp/homybackup.ucs
sudo chmod 666 /tmp/homybackup.ucs

# For F5_HOST
sshpass -p "$F5_PASSWORD" scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null $F5_USER@$F5_HOST:/var/local/ucs/ho-mybackup.ucs /tmp/homybackup.ucs

# For BACKUP_SERVER
sshpass -p "$BACKUP_SERVER_PASSWORD" scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null /tmp/homybackup.ucs netadmin@$BACKUP_SERVER:/home/netadmin/HO-Backup/F5/ho-mybackup.ucs
