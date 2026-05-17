#!/bin/bash

# Ansible managed script to set up Wazuh svc account 
useradd -r svc_wazuh -m -d /usr/wazuh -s /bin/bash -c "Wazuh Service account"

