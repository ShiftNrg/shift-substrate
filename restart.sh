#!/bin/bash
# Author: Swezey <swezey@shiftnrg.org>

echo -n "Restart Full Node or Validator? ([f]/v) "
    read RESTART
echo ""
if [ "$RESTART" == "f" ] || [ -z "$RESTART" ]; then
        sudo systemctl restart shift-substrate-node.service
    else
        sudo systemctl restart shift-substrate-validator.service
    fi