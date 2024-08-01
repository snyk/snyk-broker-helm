#!/bin/bash

if ! [ -f "admin.txt" ]; then
  echo "Ensure admin password is updated"
  exit 1
fi

## Anonymous Access
curl -X PUT \
  'http://localhost/service/rest/v1/security/anonymous' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -u admin:admin123 \
  -d '{
  "enabled": true,
  "userId": "admin",
  "realmName": "NexusAuthenticatingRealm"
}'

# Create a docker repo
curl -X POST \
  http://localhost:80/service/rest/v1/repositories/docker/hosted \
  -H "Content-Type: application/json" \
  -u admin:admin123 \
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

