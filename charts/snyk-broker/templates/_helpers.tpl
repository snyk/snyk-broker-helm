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
helm.sh/chart: {{ include "snyk-broker.chart" . }}
{{ include "snyk-broker.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "snyk-broker.selectorLabels" -}}
app.kubernetes.io/name: {{ include "snyk-broker.name" . }}{{if not .Values.disableSuffixes }}-{{ .Release.Name }}{{ end }}
app.kubernetes.io/instance: {{ .Release.Name }}
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
{{ .Values.scmType }}-broker-service-{{ .Release.Name }}
{{- else }}
{{ .Values.scmType}}-broker-service
{{- end -}}
{{- end -}}