{{/*
Expand the name of the chart.
*/}}
{{- define "nimbusguard.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "nimbusguard.fullname" -}}
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
{{- define "nimbusguard.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "nimbusguard.labels" -}}
helm.sh/chart: {{ include "nimbusguard.chart" . }}
{{ include "nimbusguard.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app: nimbusguard
{{- end }}

{{/*
Selector labels
*/}}
{{- define "nimbusguard.selectorLabels" -}}
app.kubernetes.io/name: {{ include "nimbusguard.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use for consumer
*/}}
{{- define "nimbusguard.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "nimbusguard.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the service account to use for DQN adapter
*/}}
{{- define "nimbusguard.dqnAdapter.serviceAccountName" -}}
{{- if .Values.dqnAdapter.serviceAccount.create }}
{{- default (printf "%s-dqn-adapter" (include "nimbusguard.fullname" .)) .Values.dqnAdapter.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.dqnAdapter.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the service account to use for MCP server
*/}}
{{- define "nimbusguard.mcpServer.serviceAccountName" -}}
{{- if .Values.mcpServer.serviceAccount.create }}
{{- default (printf "%s-mcp-server" (include "nimbusguard.fullname" .)) .Values.mcpServer.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.mcpServer.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the service account to use for Prometheus
*/}}
{{- define "nimbusguard.prometheus.serviceAccountName" -}}
{{- if .Values.monitoring.prometheus.serviceAccount.create }}
{{- default (printf "%s-prometheus" (include "nimbusguard.fullname" .)) .Values.monitoring.prometheus.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.monitoring.prometheus.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the service account to use for Alloy
*/}}
{{- define "nimbusguard.alloy.serviceAccountName" -}}
{{- if .Values.monitoring.alloy.serviceAccount.create }}
{{- default (printf "%s-alloy" (include "nimbusguard.fullname" .)) .Values.monitoring.alloy.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.monitoring.alloy.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the service account to use for Kube State Metrics
*/}}
{{- define "nimbusguard.kubeStateMetrics.serviceAccountName" -}}
{{- if .Values.monitoring.kubeStateMetrics.serviceAccount.create }}
{{- default (printf "%s-kube-state-metrics" (include "nimbusguard.fullname" .)) .Values.monitoring.kubeStateMetrics.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.monitoring.kubeStateMetrics.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the service account to use for Beyla
*/}}
{{- define "nimbusguard.beyla.serviceAccountName" -}}
{{- if .Values.monitoring.beyla.serviceAccount.create }}
{{- default (printf "%s-beyla" (include "nimbusguard.fullname" .)) .Values.monitoring.beyla.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.monitoring.beyla.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create image name with registry prefix if specified
*/}}
{{- define "nimbusguard.image" -}}
{{- if .Values.global.imageRegistry }}
{{- printf "%s/%s:%s" .Values.global.imageRegistry .repository .tag }}
{{- else }}
{{- printf "%s:%s" .repository .tag }}
{{- end }}
{{- end }}

{{/*
Prometheus server address for KEDA
*/}}
{{- define "nimbusguard.prometheusAddress" -}}
{{- printf "http://prometheus.%s.svc.cluster.local:9090" .Values.namespace.name }}
{{- end }} 