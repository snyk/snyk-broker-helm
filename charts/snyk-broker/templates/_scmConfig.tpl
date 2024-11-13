{{/*
Return broker client url
*/}}
{{- define "snyk-broker.brokerClientUrl" }}
- name: BROKER_CLIENT_URL
{{- if eq .Values.scmType "container-registry-agent" }}
  value: "http://{{ include "snyk-broker.brokerServiceName" . }}:{{ .Values.service.port }}"
{{- else }}
  value: {{ .Values.brokerClientUrl }}
{{- end }}
{{- end }}

{{/*
Return broker client port
*/}}
{{- define "snyk-broker.brokerClientPort" }}
- name: PORT
  value: {{ .Values.deployment.container.containerPort | squote }}
{{- end }}

{{/*
Return broker token secret name and key
*/}}
{{- define "snyk-broker.brokerTokenSecretName" -}}
{{- $suffix := ( .Values.disableSuffixes | default false ) | ternary "" ( printf "-%s" .Release.Name ) }}
{{- .Values.brokerTokenSecret.name | default ( printf "%s-broker-token%s" .Values.scmType $suffix ) }}
{{- end }}

{{/*
Return broker token secret name and key
*/}}
{{- define "snyk-broker.brokerTokenSecretKey" -}}
{{- $suffix := ( .Values.disableSuffixes | default false ) | ternary "" ( printf "-%s" .Release.Name ) }}
{{- .Values.brokerTokenSecret.key | default ( printf "%s-broker-token-key" .Values.scmType ) }}
{{- end }}

{{/*
Return broker token
*/}}
{{- define "snyk-broker.brokerToken" }}
- name: BROKER_TOKEN
  valueFrom:
    secretKeyRef:
      name: {{ include "snyk-broker.brokerTokenSecretName" . }}
      key: {{ include "snyk-broker.brokerTokenSecretKey" . }}
{{- end }}

{{/*
Return the scm token secret name and key
*/}}
{{- define "snyk-broker.scmTokenSecretName" -}}
{{- $suffix := ( .Values.disableSuffixes | default false ) | ternary "" ( printf "-%s" .Release.Name ) }}
{{- .Values.externalCredentialSecret.name | default (printf "%s-token%s" .Values.scmType $suffix ) }}
{{- end }}

{{- define "snyk-broker.scmTokenSecretKey" -}}
{{- $suffix := ( .Values.disableSuffixes | default false ) | ternary "" ( printf "-%s" .Release.Name ) }}
{{- .Values.externalCredentialSecret.key | default (printf "%s-token-key" .Values.scmType ) }}
{{- end }}

{{/*
Return the scm-specific config for token/credentials
*/}}
{{- define "snyk-broker.scmToken" }}
{{- $scm := (.Values.scmType | split "-")._0 | upper }}
{{- $envVarName := "" -}}
{{- if has .Values.scmType (list "github-com" "github-enterprise" "gitlab") }}
{{- $envVarName = (printf "%s_TOKEN" $scm) }}
{{- end }}
{{- if eq .Values.scmType "bitbucket-server" }}
{{- $envVarName = "BITBUCKET_PASSWORD" }}
{{- end }}
{{- if eq .Values.scmType "bitbucket-server-bearer-auth" }}
{{- $envVarName = "BITBUCKET_PAT" }}
{{- end }}
{{- if eq .Values.scmType "azure-repos" }}
{{- $envVarName = "AZURE_REPOS_TOKEN" }}
{{- end }}
{{- if eq .Values.scmType "jira" }}
{{- $envVarName = "JIRA_PASSWORD" }}
{{- end }}
{{- if eq .Values.scmType "jira-bearer-auth" }}
{{- $envVarName = "JIRA_PAT" }}
{{- end }}
{{- if eq .Values.scmType "container-registry-agent" }}
{{- if not (has .Values.crType (list "ecr" "digitalocean-cr")) }}
{{- $envVarName = "CR_PASSWORD" }}
{{- else }}
{{- if eq .Values.crType "digitalocean-cr" }}
{{- $envVarName = "CR_TOKEN" }}
{{- end }}
{{- end }}
{{- end }}
{{- if not (and  .Values.scmTokenPool .Values.useExternalSecretScmTokenPool ) }}
{{- if $envVarName }}
- name: {{ $envVarName }}
  valueFrom:
    secretKeyRef:
      name: {{ include "snyk-broker.scmTokenSecretName" . }}
      key: {{ include "snyk-broker.scmTokenSecretKey" . }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Return the Artifactory URL secret name and key
*/}}
{{- define "snyk-broker.artifactoryUrlSecretName" -}}
{{- $suffix := ( .Values.disableSuffixes | default false ) | ternary "" ( printf "-%s" .Release.Name ) }}
{{- .Values.artifactoryUrlSecret.name | default (printf "artifactory-url%s" $suffix ) }}
{{- end }}

{{- define "snyk-broker.artifactoryUrlSecretKey" -}}
{{- $suffix := ( .Values.disableSuffixes | default false ) | ternary "" ( printf "-%s" .Release.Name ) }}
{{- .Values.artifactoryUrlSecret.key | default "artifactory-url" }}
{{- end }}

{{/*
Artifactory URL
*/}}
{{- define "snyk-broker.artifactoryUrl" }}
- name: ARTIFACTORY_URL
  valueFrom:
    secretKeyRef:
      name: {{ include "snyk-broker.artifactoryUrlSecretName" . }}
      key: {{ include "snyk-broker.artifactoryUrlSecretKey" . }}
{{- end }}

{{/*
Return the Nexus Base URL secret name and key
*/}}
{{- define "snyk-broker.baseNexusUrlSecretName" -}}
{{- $suffix := ( .Values.disableSuffixes | default false ) | ternary "" ( printf "-%s" .Release.Name ) }}
{{- .Values.baseNexusUrlSecret.name | default (printf "nexus-base-nexus-url%s" $suffix) }}
{{- end }}

{{- define "snyk-broker.baseNexusUrlSecretKey" -}}
{{- $suffix := ( .Values.disableSuffixes | default false ) | ternary "" ( printf "-%s" .Release.Name ) }}
{{- .Values.baseNexusUrlSecret.key | default "nexus-base-nexus-url" }}
{{- end }}

{{/*
Nexus Urls
*/}}
{{- define "snyk-broker.baseNexusUrl" }}
- name: BASE_NEXUS_URL
  valueFrom:
    secretKeyRef:
      name: {{ include "snyk-broker.baseNexusUrlSecretName" . }}
      key: {{ include "snyk-broker.baseNexusUrlSecretKey" . }}
{{- end }}

{{/*
Return the Nexus URL secret name and key
*/}}
{{- define "snyk-broker.nexusUrlSecretName" -}}
{{- $suffix := ( .Values.disableSuffixes | default false ) | ternary "" ( printf "-%s" .Release.Name ) }}
{{- .Values.nexusUrlSecret.name | default (printf "nexus-nexus-url%s" $suffix) }}
{{- end }}

{{- define "snyk-broker.nexusUrlSecretKey" -}}
{{- $suffix := ( .Values.disableSuffixes | default false ) | ternary "" ( printf "-%s" .Release.Name ) }}
{{- .Values.nexusUrlSecret.key | default "nexus-nexus-url" }}
{{- end }}

{{- define "snyk-broker.nexusUrl" }}
{{- $suffix := ( .Values.disableSuffixes | default false ) | ternary "" ( printf "-%s" .Release.Name ) }}
- name: NEXUS_URL
  valueFrom:
    secretKeyRef:
      name: {{ include "snyk-broker.nexusUrlSecretName" . }}
      key: {{ include "snyk-broker.nexusUrlSecretKey" . }}
{{- end }}


{{/*
Return Sonarqube url
*/}}
{{- define "snyk-broker.sonarqubeHostUrl" }}
- name: SONARQUBE_HOST_URL
  value: {{ .Values.sonarqubeHostUrl }}
{{- end }}
{{/*
Return the Sonarqube API Token secret name and key
*/}}
{{- define "snyk-broker.sonarqubeApiTokenSecretName" -}}
{{- $suffix := ( .Values.disableSuffixes | default false ) | ternary "" ( printf "-%s" .Release.Name ) }}
{{- .Values.sonarqubeApiTokenSecret.name | default (printf "apprisk-sonarqube-api-token%s" $suffix) }}
{{- end }}

{{- define "snyk-broker.sonarqubeApiTokenSecretKey" -}}
{{- $suffix := ( .Values.disableSuffixes | default false ) | ternary "" ( printf "-%s" .Release.Name ) }}
{{- .Values.sonarqubeApiTokenSecret.key | default "apprisk-sonarqube-api-token" }}
{{- end }}

{{- define "snyk-broker.sonarqubeApiToken" }}
{{- $suffix := ( .Values.disableSuffixes | default false ) | ternary "" ( printf "-%s" .Release.Name ) }}
- name: SONARQUBE_API_TOKEN
  valueFrom:
    secretKeyRef:
      name: {{ include "snyk-broker.sonarqubeApiTokenSecretName" . }}
      key: {{ include "snyk-broker.sonarqubeApiTokenSecretKey" . }}
{{- end }}

{{/*
Return checkmarx host
*/}}
{{- define "snyk-broker.checkmarx" }}
- name: CHECKMARX
  value: {{ .Values.checkmarx }}
{{- end }}

{{/*
Return the Broker Client Validation URL secret name and key
*/}}
{{- define "snyk-broker.brokerClientValidationUrlSecretName" -}}
{{- $suffix := ( .Values.disableSuffixes | default false ) | ternary "" ( printf "-%s" .Release.Name ) }}
{{- .Values.brokerClientValidationUrlSecret.name | default (printf "%s-broker-client-validation-url%s" .Values.scmType $suffix ) }}
{{- end }}

{{- define "snyk-broker.brokerClientValidationUrlSecretKey" -}}
{{- $suffix := ( .Values.disableSuffixes | default false ) | ternary "" ( printf "-%s" .Release.Name ) }}
{{- .Values.brokerClientValidationUrlSecret.key | default ( printf "%s-broker-client-validation-url" .Values.scmType ) }}
{{- end }}


{{/*
Broker Client Validation URL
*/}}
{{- define "snyk-broker.brokerClientValidationUrl" }}
{{- if or (eq .Values.scmType "artifactory") (contains "nexus" .Values.scmType ) }}
- name: BROKER_CLIENT_VALIDATION_URL
  valueFrom:
    secretKeyRef:
      name: {{ include "snyk-broker.brokerClientValidationUrlSecretName" . }}
      key: {{ include "snyk-broker.brokerClientValidationUrlSecretKey" . }}
{{- end }}
{{- end }}

{{/*
Return the SCM Token Pool secret name and key
*/}}
{{- define "snyk-broker.scmTokenPoolSecretName" -}}
{{- $suffix := ( .Values.disableSuffixes | default false ) | ternary "" ( printf "-%s" .Release.Name ) }}
{{- .Values.scmTokenPoolSecret.name | default (printf "%s-token-pool%s" .Values.scmType $suffix ) }}
{{- end }}

{{- define "snyk-broker.scmTokenPoolSecretKey" -}}
{{- $suffix := ( .Values.disableSuffixes | default false ) | ternary "" ( printf "-%s" .Release.Name ) }}
{{- .Values.scmTokenPoolSecret.key | default ( printf "%s-token-pool-key" .Values.scmType ) }}
{{- end }}

{{/*
SCM Token pooling
*/}}
{{- define "snyk-broker.scmTokenPool" }}
{{- $scm := (.Values.scmType | split "-")._0 | upper -}}
{{- if has .Values.scmType (list "github-com" "github-enterprise" "gitlab") }}
{{- if or .Values.scmTokenPool .Values.useExternalSecretScmTokenPool }}
- name: {{ printf "%s_TOKEN_POOL" $scm }}
  valueFrom:
    secretKeyRef:
      name: {{ include "snyk-broker.scmTokenPoolSecretName" . }}
      key: {{ include "snyk-broker.scmTokenPoolSecretKey" . }}
{{- end }}
{{- end }}
{{- end }}

{{/*
If supported, return a token pool or a single token
Only the following SCMs support pooling:
GITHUB_TOKEN (github-com, github-enterprise)
GITLAB_TOKEN (gitlab)
*/}}
{{- define "snyk-broker.scmTokenOrPool" -}}
{{- include "snyk-broker.scmToken" . }}
{{- include "snyk-broker.scmTokenPool" . }}
{{- end }}

{{/*
Return sonarqube config for apprisk
*/}}
{{- define "snyk-broker.apprisktype" }}
{{- if or (and .Values.sonarqubeHostUrl (ne .Values.sonarqubeHostUrl "")) (and .Values.checkmarx (ne .Values.checkmarx "")) }}
{{- if and .Values.sonarqubeHostUrl (ne .Values.sonarqubeHostUrl "") }}
{{- include "snyk-broker.sonarqubeHostUrl" . }}
{{- include "snyk-broker.sonarqubeApiToken" . }}
{{- end}}
{{- if and .Values.checkmarx (ne .Values.checkmarx "") }}
{{- include "snyk-broker.checkmarx" . }}
{{- end}}
{{- else}}
{{- fail "Error: Either or both .Values.sonarqubeHostUrl or .Values.checkmarx must be defined and not empty." }}
{{- end }}
{{- end }}


{{/*
  Define apprisk values
  */}}
  {{- define "snyk-broker.apprisk" -}}
  {{- if eq .Values.scmType "apprisk" }}
  {{- include "snyk-broker.apprisktype" . }}
  {{- end }}
  {{- end }}

{{/*
Define github-com values
*/}}
{{- define "snyk-broker.githubCom" -}}
{{- if eq .Values.scmType "github-com" }}
{{- include "snyk-broker.brokerToken" . }}
{{- include "snyk-broker.scmTokenOrPool" . }}
{{- include "snyk-broker.brokerClientPort" . }}
{{- include "snyk-broker.brokerClientUrl" . }}
{{- end }}
{{- end }}

{{/*
Define github-enterprise values
*/}}
{{- define "snyk-broker.githubEnterprise" -}}
{{- if eq .Values.scmType "github-enterprise" }}
{{- include "snyk-broker.brokerToken" . }}
{{- include "snyk-broker.scmTokenOrPool" . }}
{{- include "snyk-broker.brokerClientPort" . }}
{{- include "snyk-broker.brokerClientUrl" . }}
- name: GITHUB
  value: {{ .Values.github }}
- name: GITHUB_API
  value: {{ .Values.githubApi }}
- name: GITHUB_GRAPHQL
  value: {{ .Values.githubGraphQl}}
{{- end }}
{{- end }}

{{/*
Define gitlab values
*/}}
{{- define "snyk-broker.gitlab" -}}
{{- if eq .Values.scmType "gitlab" }}
{{- include "snyk-broker.brokerToken" . }}
{{- include "snyk-broker.scmTokenOrPool" . }}
- name: GITLAB
  value: {{ .Values.gitlab }}
{{- include "snyk-broker.brokerClientPort" . }}
{{- include "snyk-broker.brokerClientUrl" . }}
{{- end }}
{{- end }}

{{/*
Define bitbucket-server values
*/}}
{{- define "snyk-broker.bitbucketServer" -}}
{{- if eq .Values.scmType "bitbucket-server" }}
{{- include "snyk-broker.brokerToken" . }}
{{- include "snyk-broker.brokerClientPort" . }}
{{- include "snyk-broker.brokerClientUrl" . }}
{{- include "snyk-broker.scmTokenOrPool" . }}
- name: BITBUCKET_USERNAME
  value: {{ .Values.bitbucketUsername }}
{{- include "snyk-broker.scmTokenOrPool" . }}
- name: BITBUCKET
  value: {{ .Values.bitbucket }}
- name: BITBUCKET_API
  value: {{ .Values.bitbucketApi }}
{{- end }}
{{- end }}

{{/*
Define bitbucket-server-bearer-auth values
*/}}
{{- define "snyk-broker.bitbucketServerBearerAuth" -}}
{{- if eq .Values.scmType "bitbucket-server-bearer-auth" }}
{{- include "snyk-broker.brokerToken" . -}}
{{- include "snyk-broker.brokerClientPort" . }}
{{- include "snyk-broker.brokerClientUrl" . }}
{{- include "snyk-broker.scmTokenOrPool" . }}
- name: BITBUCKET
  value: {{ .Values.bitbucket }}
- name: BITBUCKET_API
  value: {{ .Values.bitbucketApi }}
{{- end }}
{{- end }}

{{/*
Define azure-repos values
*/}}
{{- define "snyk-broker.azureRepos" -}}
{{- if eq .Values.scmType "azure-repos" }}
{{- include "snyk-broker.brokerToken" . }}
{{- include "snyk-broker.brokerClientPort" . }}
{{- include "snyk-broker.brokerClientUrl" . }}
{{- include "snyk-broker.scmTokenOrPool" . }}
- name: AZURE_REPOS_ORG
  value: {{ .Values.azureReposOrg }}
- name: AZURE_REPOS_HOST
  value: {{ .Values.azureReposHost }}
{{- end }}
{{- end }}

{{/*
Define artifactory values
*/}}
{{- define "snyk-broker.artifactory" -}}
{{- if eq .Values.scmType "artifactory" }}
{{- include "snyk-broker.brokerToken" . }}
{{- include "snyk-broker.brokerClientPort" . }}
{{- include "snyk-broker.brokerClientUrl" . }}
{{- include "snyk-broker.artifactoryUrl" . }}
{{- if or .Values.brokerClientValidationUrl .Values.brokerClientValidationUrlSecret.key .Values.brokerClientValidationUrlSecret.name }}
{{- include "snyk-broker.brokerClientValidationUrl" . }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Define Nexus 3/2 values
*/}}
{{- define "snyk-broker.nexus" -}}
{{- if contains "nexus" .Values.scmType }}
{{- if and .Values.nexusUrlSecret.key .Values.baseNexusUrlSecret.key -}}
{{- if eq .Values.nexusUrlSecret.key .Values.baseNexusUrlSecret.key -}}
{{- fail "Secret keys for nexusUrlSecret and baseNexusUrlSecret must be unique" -}}
{{- end }}
{{- end }}
{{- include "snyk-broker.brokerToken" . }}
{{- include "snyk-broker.brokerClientPort" . }}
{{- include "snyk-broker.baseNexusUrl" . }}
{{- include "snyk-broker.nexusUrl" . }}
{{- if or .Values.brokerClientValidationUrl .Values.brokerClientValidationUrlSecret.key .Values.brokerClientValidationUrlSecret.name }}
{{- include "snyk-broker.brokerClientValidationUrl" . }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Define Jira
*/}}
{{- define "snyk-broker.jira" -}}
{{- if eq .Values.scmType "jira" }}
{{- include "snyk-broker.brokerToken" . }}
{{- include "snyk-broker.brokerClientPort" . }}
{{- include "snyk-broker.brokerClientUrl" . }}
- name: JIRA_USERNAME
  value: {{ .Values.jiraUsername }}
{{- include "snyk-broker.scmTokenOrPool" . }}
- name: JIRA_HOSTNAME
  value: {{ .Values.jiraHostname }}
{{- end }}
{{- end }}

{{/*
Define Jira Bearer Auth
*/}}
{{- define "snyk-broker.jiraBearerAuth" -}}
{{- if eq .Values.scmType "jira-bearer-auth" }}
{{- include "snyk-broker.brokerToken" . }}
{{- include "snyk-broker.brokerClientPort" . }}
{{- include "snyk-broker.brokerClientUrl" . }}
{{- include "snyk-broker.scmTokenOrPool" . }}
- name: JIRA_HOSTNAME
  value: {{ .Values.jiraHostname }}
{{- end }}
{{- end }}

{{/*
Define Container Registry Agent
*/}}
{{- define "snyk-broker.containerRegistryAgent" }}
{{- if eq .Values.scmType "container-registry-agent" }}
{{- include "snyk-broker.brokerToken" . }}
- name: CR_AGENT_URL
  value: http://cra-service{{if not .Values.disableSuffixes }}-{{ .Release.Name }}{{ end }}:{{ .Values.deployment.container.crSnykPort | toString }}
- name: CR_TYPE
  value: {{ .Values.crType }}
{{- if not (has .Values.crType (list "ecr")) }}
- name: CR_BASE
  value: {{ .Values.crBase }}
{{- else }}
- name: CR_ROLE_ARN
  value: {{ .Values.crRoleArn }}
- name: CR_REGION
  value: {{ .Values.crRegion }}
- name: CR_EXTERNAL_ID
  value: {{ .Values.crExternalId }}
{{- end }}
{{- if not (has .Values.crType (list "ecr" "digitalocean-cr")) }}
- name: CR_USERNAME
  value: {{ .Values.crUsername }}
{{- end }}
{{- include "snyk-broker.scmToken" . }}
{{- include "snyk-broker.brokerClientPort" . }}
{{- include "snyk-broker.brokerClientUrl" . }}
- name: BROKER_CLIENT_VALIDATION_URL
  value: http://cra-service{{if not .Values.disableSuffixes }}-{{ .Release.Name }}{{ end }}:{{ .Values.deployment.container.crSnykPort | toString }}/healthcheck
{{- end }}
{{- end }}
