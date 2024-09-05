{{/*
*/}}
{{- define "snyk-broker.requiredSecrets" -}}
{{- $scmTemplates := (list "scmTokenOrPool") }}
{{- $artifactoryTemplates := (list "artifactoryUrl" "brokerClientValidationUrl" ) }}
{{- $nexusTemplates := (list "baseNexusUrl" "nexusUrl" "brokerClientValidationUrl" )}}
{{- $containerRegistryAgentTemplates := (list "scmToken" )}}
{{- $templatesPerType := (dict "github-com" $scmTemplates "github-enterprise" $scmTemplates "gitlab" $scmTemplates "bitbucket-server" $scmTemplates "bitbucket-server-bearer-auth" $scmTemplates "azure-repos" $scmTemplates "artifactory" $artifactoryTemplates "nexus" $nexusTemplates "jira" $scmTemplates "jira-bearer-auth" $scmTemplates "container-registry-agent" $containerRegistryAgentTemplates ) }}
{{- if not .Values.useExternalSecrets -}}
{{- if not .Values.brokerToken }}
{{ printf "-> %s:%s <your-broker-token>" (include "snyk-broker.brokerTokenSecretName" . ) (include "snyk-broker.brokerTokenSecretKey" . ) }}
{{- end }}
{{- range (get $templatesPerType .Values.scmType ) }}
{{- $secretObject :=  (first (fromYamlArray (include (printf "snyk-broker.%s" . ) $ ))) }}
{{- $envName := $secretObject.name }}
{{- $name := $secretObject.valueFrom.secretKeyRef.name }}
{{- $key := $secretObject.valueFrom.secretKeyRef.key }}
{{ printf "-> %s:%s <%s>" $name $key $envName }}
{{- end }}
{{- if .Values.httpsSecret.name }}
{{ printf "-> %s:%s <your-certificate>" .Values.httpsSecret.name "tls.crt" }}
{{ printf "-> %s:%s <your-certificate-key>" .Values.httpsSecret.name "tls.key" }}
{{- end }}
{{- if (and .Values.caCertFileSecret.name .Values.caCertFileSecret.key ) }}
{{ printf "-> %s:%s <your-pem-certificate-material>" .Values.caCertFileSecret.name .Values.caCertFileSecret.key }}
{{- end }}
{{- end }}
{{- end }}
