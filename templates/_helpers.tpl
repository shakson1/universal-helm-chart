


{{- define "universal-app.name" -}}
{{ .Chart.Name }}
{{- end }}

{{- define "universal-app.fullname" -}}
{{ printf "%s-%s" .Release.Name .Chart.Name }}
{{- end }}

{{- define "universal-app.labels" -}}
app.kubernetes.io/name: {{ include "universal-app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}