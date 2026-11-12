{{- define "harness-gitops-agent-controller.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "harness-gitops-agent-controller.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "harness-gitops-agent-controller.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "harness-gitops-agent-controller.labels" -}}
helm.sh/chart: {{ include "harness-gitops-agent-controller.chart" . }}
{{ include "harness-gitops-agent-controller.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "harness-gitops-agent-controller.selectorLabels" -}}
app.kubernetes.io/name: {{ include "harness-gitops-agent-controller.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "harness-gitops-agent-controller.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
{{- default (include "harness-gitops-agent-controller.fullname" .) .Values.serviceAccount.name -}}
{{- else -}}
{{- required "serviceAccount.name must be set when serviceAccount.create=false" .Values.serviceAccount.name -}}
{{- end -}}
{{- end -}}
