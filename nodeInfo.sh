#!/bin/bash
# Author: Swezey <swezey@shiftnrg.org>

CURL_CMD='curl http://localhost:9933 -H "Content-Type:application/json;charset=utf-8" -d'

echo "/// Node Info \\\\\\"
echo ""
curl http://localhost:9933 -H "Content-Type:application/json;charset=utf-8" -d "@./json/nodeRole.json"
echo ""
curl http://localhost:9933 -H "Content-Type:application/json;charset=utf-8" -d "@./json/verifyAura.json"
echo ""
curl http://localhost:9933 -H "Content-Type:application/json;charset=utf-8" -d "@./json/verifyGran.json"