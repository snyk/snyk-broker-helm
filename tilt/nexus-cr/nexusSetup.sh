#!/bin/bash

if ! [ -f "admin.txt" ]; then
  echo "Ensure admin password is updated"
  exit 1
fi

## Anonymous Access
curl -X PUT \
  'https://localhost:8443/service/rest/v1/security/anonymous' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -u admin:admin123 \
  -k \
  --fail-with-body \
  -d '{
  "enabled": true,
  "userId": "admin",
  "realmName": "NexusAuthenticatingRealm"
}'

# Create a docker repo
curl -X POST \
  https://localhost:8443/service/rest/v1/repositories/docker/hosted \
  -H "Content-Type: application/json" \
  -k \
  -u admin:admin123 \
  --fail-with-body \
  -d '{
    "name": "docker",
    "online": true,
    "storage": {
      "blobStoreName": "default",
        "strictContentTypeValidation": true,
        "writePolicy": "allow_once",
        "latestPolicy": true
    },
    "docker": {
      "v1Enabled": true,
      "forceBasicAuth": true,
      "httpPort": 8083
    }
  }'

