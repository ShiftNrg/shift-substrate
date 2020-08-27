#!/bin/bash

CURL_CMD='curl http://localhost:9933 -H "Content-Type:application/json;charset=utf-8" -d'

echo "/// Node Info \\\\\\"
echo ""
$CURL_CMD "@./json/nodeRole.json"
echo ""
$CURL_CMD "@./json/verifyAura.json"
echo ""
$CURL_CMD "@./json/verifyGran.json"