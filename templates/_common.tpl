{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "harness.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "harness.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return valid version label
*/}}
{{- define "harness.versionLabelValue" -}}
{{ regexReplaceAll "[^-A-Za-z0-9_.]" .Values.agent.image.tag "-" | trunc 63 | trimAll "-" | trimAll "_" | trimAll "." | quote }}
{{- end -}}

{{/*
Argo CD Common labels
*/}}
{{- define "harness.labels" -}}
helm.sh/chart: {{ include "harness.chart" .context }}
{{ include "harness.selectorLabels" (dict "context" .context "component" .component "name" .name) }}
app.kubernetes.io/managed-by: {{ .context.Release.Service }}
app.kubernetes.io/part-of: harness-gitops
app.kubernetes.io/version: {{ include "harness.versionLabelValue" .context }}
{{- with .context.Values.global.additionalLabels }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{/*
Harness Common labels
*/}}
{{- define "harness.agentLabels" -}}
helm.sh/chart: {{ include "harness.chart" .context }}
{{ include "harness.agentSelectorLabels" (dict "context" .context "component" .component "name" .name) }}
app.kubernetes.io/managed-by: {{ .context.Release.Service }}
app.kubernetes.io/part-of: harness-gitops
app.kubernetes.io/version: {{ include "harness.versionLabelValue" .context }}
{{- with .context.Values.global.additionalLabels }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{/*
Argo CD Selector labels
*/}}
{{- define "harness.selectorLabels" -}}
{{- if .name -}}
app.kubernetes.io/name: {{ include "harness.name" .context }}-{{ .name }}
{{ end -}}
app.kubernetes.io/instance: {{ .context.Release.Name }}
{{- if .component }}
app.kubernetes.io/component: {{ .component }}
{{- end }}
{{- end }}

{{/*
Harness Selector labels
*/}}
{{- define "harness.agentSelectorLabels" -}}
{{- if .name -}}
app.kubernetes.io/name: {{ .context.Values.harness.nameOverride }}-{{ .name }}
{{ end -}}
app.kubernetes.io/instance: {{ .context.Release.Name }}
{{- if .component }}
app.kubernetes.io/component: {{ .component }}
{{- end }}
{{- end }}

{{/*
Create the name of the GitOps Agent service account to use
*/}}
{{- define "harness.agent.serviceAccountName" -}}
{{- if .Values.agent.serviceAccount.create -}}
    {{ default .Values.agent.name .Values.agent.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.agent.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Disaster Recovery cluster name
*/}}
{{- define "harness.agentClusterName" -}}
{{- if .Values.harness.disasterRecovery.enabled -}}
    {{ .Values.agent.harnessName }}-agent-{{ .Values.harness.disasterRecovery.identifier }}
{{- else -}}
    {{ .Values.agent.harnessName }}-agent
{{- end -}}
{{- end -}}

{{/*
Set value for redis server, this can be used in case of external redis server also
just set the value of .Values.harness.configMap.argocd.redisSvc
*/}}
{{- define "redisServer" -}}
    {{- if .Values.harness.configMap.argocd.redisSvc -}}
      {{- .Values.harness.configMap.argocd.redisSvc -}}
    {{- else -}}
      {{- if .Values.agent.highAvailability -}}
        {{- .Values.harness.configMap.argocd.redisHaProxySvc -}}
      {{- else -}}
        {{- .Values.harness.configMap.argocd.redis -}}
      {{- end -}}
    {{- end -}}
{{- end -}}
