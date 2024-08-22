#!/bin/bash
set -x
## Get the nexus3 admin password and write to disk
ADMIN_PASSWORD=$(kubectl exec "$(tilt get kd nexus3 -ojsonpath='{.status.pods[0].name}')" -- cat /nexus-data/admin.password)
echo "$ADMIN_PASSWORD" > admin.txt
# Change the initial password to admin123
curl -ifu "admin:$ADMIN_PASSWORD" \
  --fail \
  -k \
  -X PUT \
  -H 'Content-Type: text/plain' \
  --data "admin123" \
  https://localhost:8443/service/rest/v1/security/users/admin/change-password
