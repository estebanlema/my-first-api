{{/*
Expand the name of the chart.
*/}}
{{- define "my-first-api.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "my-first-api.fullname" -}}
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
{{- define "my-first-api.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "my-first-api.labels" -}}
helm.sh/chart: {{ include "my-first-api.chart" . }}
{{ include "my-first-api.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
API selector labels
*/}}
{{- define "my-first-api.selectorLabels" -}}
app.kubernetes.io/name: {{ include "my-first-api.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
PostgreSQL selector labels
*/}}
{{- define "my-first-api.postgresql.selectorLabels" -}}
app.kubernetes.io/name: {{ include "my-first-api.name" . }}-postgresql
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "my-first-api.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "my-first-api.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
PostgreSQL service hostname (used for DATABASE_URL)
*/}}
{{- define "my-first-api.postgresql.host" -}}
{{- printf "%s-postgresql" (include "my-first-api.fullname" .) }}
{{- end }}

{{/*
Full DATABASE_URL
*/}}
{{- define "my-first-api.databaseUrl" -}}
{{- printf "postgresql://%s:%s@%s:5432/%s" .Values.postgresql.auth.username .Values.postgresql.auth.password (include "my-first-api.postgresql.host" .) .Values.postgresql.auth.database }}
{{- end }}
