#!/bin/bash

if [ "$1" = 'bash' ]; then
    bash
else
    ansible-playbook -vv $@
fi
