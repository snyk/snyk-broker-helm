{{/*
Expand the name of the chart.
*/}}
{{- define "snyk-broker.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "snyk-broker.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "snyk-broker.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "snyk-broker.labels" -}}
{{- $commonLabels := dict "helm.sh/chart" (include "snyk-broker.chart" .) }}
{{- $commonLabels = merge $commonLabels (include "snyk-broker.selectorLabels" . | fromYaml) }}
{{- if .Chart.AppVersion }}
{{- $commonLabels = merge $commonLabels (dict "app.kubernetes.io/version" (quote .Chart.AppVersion)) }}
{{- end }}
{{- $commonLabels = merge $commonLabels (dict "app.kubernetes.io/managed-by" .Release.Service) }}
{{- with .Values.labels }}
{{- $commonLabels = merge $commonLabels . }}
{{- end }}
{{- toYaml $commonLabels | nindent 4 }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "snyk-broker.selectorLabels" -}}
app.kubernetes.io/name: {{ include "snyk-broker.name" . }}{{if not .Values.disableSuffixes }}-{{ .Release.Name }}{{ end }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Pod labels (merge normal labels and selectors)
*/}}
{{- define "snyk-broker.podLabels" -}}
{{- merge (include "snyk-broker.labels" . | fromYaml ) (include "snyk-broker.selectorLabels" . | fromYaml) | toYaml -}}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "snyk-broker.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "snyk-broker.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Content of accept.json configuration file (either provided as literal value)
*/}}
{{- define "snyk-broker.acceptJson" -}}
{{- with .Values.acceptJson}}{{.}}{{end}}
{{- end}}

{{/*
Return the appropriate apiVersion for ingress.
*/}}
{{- define "snyk-broker.ingress.apiVersion" -}}
  {{- if and (.Capabilities.APIVersions.Has "networking.k8s.io/v1") (semverCompare ">= 1.19-0" .Capabilities.KubeVersion.Version) -}}
      {{- print "networking.k8s.io/v1" -}}
  {{- else if .Capabilities.APIVersions.Has "networking.k8s.io/v1beta1" -}}
    {{- print "networking.k8s.io/v1beta1" -}}
  {{- else -}}
    {{- print "extensions/v1beta1" -}}
  {{- end -}}
{{- end -}}

{{/*
Return if ingress is stable.
*/}}
{{- define "snyk-broker.ingress.isStable" -}}
  {{- eq (include "snyk-broker.ingress.apiVersion" .) "networking.k8s.io/v1" -}}
{{- end -}}
{{/*
Return if ingress supports ingressClassName.
*/}}
{{- define "snyk-broker.ingress.supportsIngressClassName" -}}
  {{- or (eq (include "snyk-broker.ingress.isStable" .) "true") (and (eq (include "snyk-broker.ingress.apiVersion" .) "networking.k8s.io/v1beta1") (semverCompare ">= 1.18-0" .Capabilities.KubeVersion.Version)) -}}
{{- end -}}
{{/*
Return if ingress supports pathType.
*/}}
{{- define "snyk-broker.ingress.supportsPathType" -}}
  {{- or (eq (include "snyk-broker.ingress.isStable" .) "true") (and (eq (include "snyk-broker.ingress.apiVersion" .) "networking.k8s.io/v1beta1") (semverCompare ">= 1.18-0" .Capabilities.KubeVersion.Version)) -}}
{{- end -}}

{{/*
Create the name of the broker service to use
*/}}
{{- define "snyk-broker.brokerServiceName" -}}
{{- if not .Values.disableSuffixes -}}
{{- $service := "-broker-service-" -}}
{{- $serviceLength := len $service -}}
{{- $releaseNameLength := len .Release.Name -}}
{{- $truncatedLength := int (sub 63 (add $serviceLength $releaseNameLength)) -}}
{{- .Values.scmType | trunc $truncatedLength }}{{ $service }}{{ .Release.Name }}
{{- else }}
{{- .Values.scmType | trunc 47 }}-broker-service
{{- end -}}
{{- end -}}

{{/*
Create a secret name.
Pass a dict of Context ($) and secretName:
include "snyk-broker.genericSecretName" (dict "Context" $ "secretName" "secret-name")
*/}}
{{- define "snyk-broker.genericSecretName" -}}
{{- if not .Context.Values.disableSuffixes -}}
{{ printf "%s-%s" ( include "snyk-broker.fullname" .Context ) .secretName }}
{{- else -}}
{{- printf "snyk-broker-%s" .secretName }}
{{- end -}}
{{- end -}}

{{- define "snyk-broker.tlsSecretName" -}}
{{- .Values.httpsSecret.name | default ( include "snyk-broker.genericSecretName" (dict "Context" . "secretName" "tls-secret" ) ) -}}
{{- end }}

{{- define "snyk-broker.caCertSecretName" -}}
{{- .Values.caCertFileSecret.name | default ( include "snyk-broker.genericSecretName" (dict "Context" . "secretName" "cacert-secret" ) ) -}}
{{- end }}

{{/*
Handle tlsRejectUnauthorized.
If this is set to `false` (bool) we _want_ to disable trust. We don't allow `true`.
If this is set to "" we want to enable trust - any other allowed string value disables.
If this is set to `"0"` Helm might cast it as an integer - we need to catch that.
Checking for definition is insufficient
*/}}
{{- define "snyk-broker.setTlsRejectUnauthorized" -}}
{{- $tlsRejectUnauthorized := .Values.tlsRejectUnauthorized -}}
{{- if eq (kindOf $tlsRejectUnauthorized ) "bool" -}}
true
{{- end }}
{{- if ( and ( eq (kindOf $tlsRejectUnauthorized ) "string") ( not ( eq $tlsRejectUnauthorized "" ) ) ) -}}
true
{{- end }}
{{- if eq (toString $tlsRejectUnauthorized) "0" -}}
true
{{- end }}
{{- end }}

{{/*
NoProxy helper
Ensure all values are trimmed, separated by comma, and do not contain protocol or port
Validate against RFC 1123
*/}}
{{- define "snyk-broker.noProxy" -}}
{{- $proxyUrls := .Values.noProxy | nospace -}}
{{- $proxyUrlsWithoutProtocol := mustRegexReplaceAll "http(s?)://" $proxyUrls "" -}}
{{- $sanitisedProxyUrls := "" -}}
{{- range $proxyUrlsWithoutProtocol | split "," -}}
{{- if ( mustRegexMatch "^[a-zA-Z0-9.-]+$" . ) -}}
{{- $sanitisedProxyUrls = printf "%s,%s" $sanitisedProxyUrls . -}}
{{- else }}
{{- fail (printf "Entry %s for .Values.noProxy is invalid. Specify hostname only (no schema or port)" . ) -}}
{{- end }}
{{- end }}
{{- $sanitisedProxyUrls |  trimPrefix "," -}}
{{- end }}

{{/*
Values are taken from .Values.securityContext.
When .Values.openshift is true, the runAsUser field is omitted.
*/}}
{{- define "snyk-broker.securityContext" -}}
{{- $root := . -}}
{{- $csc := $root.Values.securityContext | default dict -}}
{{- $sc := ternary (omit $csc "runAsUser" "runAsGroup") $csc $root.Values.openshift -}}
{{ toYaml $sc | nindent 2 }}
{{- end }}
