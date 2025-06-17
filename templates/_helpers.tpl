{{/*
Expand the name of the chart.
*/}}
{{- define "nimbusguard.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a fullname using the release name and chart name.
*/}}
{{- define "nimbusguard.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name (include "nimbusguard.name" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "nimbusguard.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

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
{{- with .Values.global.commonLabels }}
{{ toYaml . }}
{{- end }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "nimbusguard.selectorLabels" -}}
app.kubernetes.io/name: {{ include "nimbusguard.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Operator specific labels
*/}}
{{- define "nimbusguard.operatorLabels" -}}
{{ include "nimbusguard.labels" . }}
app.kubernetes.io/component: operator
{{- end -}}

{{/*
Operator selector labels
*/}}
{{- define "nimbusguard.operatorSelectorLabels" -}}
{{ include "nimbusguard.selectorLabels" . }}
app.kubernetes.io/component: operator
{{- end -}}

{{/*
Consumer workload specific labels
*/}}
{{- define "nimbusguard.consumerWorkloadLabels" -}}
{{ include "nimbusguard.labels" . }}
app.kubernetes.io/component: consumer-workload
{{- end -}}

{{/*
Consumer workload selector labels
*/}}
{{- define "nimbusguard.consumerWorkloadSelectorLabels" -}}
{{ include "nimbusguard.selectorLabels" . }}
app.kubernetes.io/component: consumer-workload
{{- end -}}

{{/*
Kafka specific labels
*/}}
{{- define "nimbusguard.kafkaLabels" -}}
{{ include "nimbusguard.labels" . }}
app.kubernetes.io/component: kafka
{{- end -}}

{{/*
Kafka selector labels
*/}}
{{- define "nimbusguard.kafkaSelectorLabels" -}}
{{ include "nimbusguard.selectorLabels" . }}
app.kubernetes.io/component: kafka
{{- end -}}

{{/*
Load generator specific labels
*/}}
{{- define "nimbusguard.loadGeneratorLabels" -}}
{{ include "nimbusguard.labels" . }}
app.kubernetes.io/component: load-generator
{{- end -}}

{{/*
Load generator selector labels
*/}}
{{- define "nimbusguard.loadGeneratorSelectorLabels" -}}
{{ include "nimbusguard.selectorLabels" . }}
app.kubernetes.io/component: load-generator
{{- end -}}

{{/*
KEDA specific labels
*/}}
{{- define "nimbusguard.kedaLabels" -}}
{{ include "nimbusguard.labels" . }}
app.kubernetes.io/component: keda-scaler
{{- end -}}

{{/*
Create the name of the service account to use for the operator
*/}}
{{- define "nimbusguard.serviceAccountName" -}}
{{- if .Values.operator.serviceAccount.create -}}
    {{ default (printf "%s-operator" (include "nimbusguard.fullname" .)) .Values.operator.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.operator.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the namespace to use
*/}}
{{- define "nimbusguard.namespace" -}}
{{- default .Release.Namespace .Values.global.namespace -}}
{{- end -}}

{{/*
Create CRD hook annotations
*/}}
{{- define "nimbusguard.crdHookAnnotations" -}}
"helm.sh/hook": {{ .Values.hooks.crd.policy | quote }}
"helm.sh/hook-weight": {{ .Values.hooks.crd.weight | quote }}
"helm.sh/hook-delete-policy": {{ .Values.hooks.crd.deletePolicy | quote }}
{{- end -}}

{{/*
Create operator hook annotations
*/}}
{{- define "nimbusguard.operatorHookAnnotations" -}}
"helm.sh/hook": {{ .Values.hooks.operator.policy | quote }}
"helm.sh/hook-weight": {{ .Values.hooks.operator.weight | quote }}
"helm.sh/hook-delete-policy": {{ .Values.hooks.operator.deletePolicy | quote }}
{{- end -}}

{{/*
Create wait job hook annotations
*/}}
{{- define "nimbusguard.waitHookAnnotations" -}}
"helm.sh/hook": {{ .Values.hooks.wait.policy | quote }}
"helm.sh/hook-weight": {{ .Values.hooks.wait.weight | quote }}
"helm.sh/hook-delete-policy": {{ .Values.hooks.wait.deletePolicy | quote }}
{{- end -}}

{{/*
Create workload hook annotations
*/}}
{{- define "nimbusguard.workloadHookAnnotations" -}}
"helm.sh/hook": {{ .Values.hooks.workloads.policy | quote }}
"helm.sh/hook-weight": {{ .Values.hooks.workloads.weight | quote }}
"helm.sh/hook-delete-policy": {{ .Values.hooks.workloads.deletePolicy | quote }}
{{- end -}}

{{/*
Create prometheus annotations
*/}}
{{- define "nimbusguard.prometheusAnnotations" -}}
{{- if .Values.monitoring.prometheus.enabled }}
prometheus.io/scrape: "true"
prometheus.io/port: {{ .Values.monitoring.prometheus.port | quote }}
prometheus.io/path: {{ .Values.monitoring.prometheus.path | quote }}
{{- end }}
{{- end -}}
