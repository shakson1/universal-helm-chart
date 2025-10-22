{{/*
Expand the name of the chart.
*/}}
{{- define "universal-app.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "universal-app.fullname" -}}
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
{{- define "universal-app.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels following Kubernetes recommended labels
*/}}
{{- define "universal-app.labels" -}}
helm.sh/chart: {{ include "universal-app.chart" . }}
{{ include "universal-app.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- with .Values.labels }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "universal-app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "universal-app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "universal-app.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "universal-app.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Return the appropriate apiVersion for HPA
*/}}
{{- define "universal-app.hpa.apiVersion" -}}
{{- if semverCompare ">=1.23-0" .Capabilities.KubeVersion.GitVersion -}}
autoscaling/v2
{{- else -}}
autoscaling/v2beta2
{{- end -}}
{{- end }}

{{/*
Return the appropriate apiVersion for PDB
*/}}
{{- define "universal-app.pdb.apiVersion" -}}
{{- if semverCompare ">=1.21-0" .Capabilities.KubeVersion.GitVersion -}}
policy/v1
{{- else -}}
policy/v1beta1
{{- end -}}
{{- end }}

{{/*
Return the appropriate apiVersion for Ingress
*/}}
{{- define "universal-app.ingress.apiVersion" -}}
{{- if semverCompare ">=1.19-0" .Capabilities.KubeVersion.GitVersion -}}
networking.k8s.io/v1
{{- else if semverCompare ">=1.14-0" .Capabilities.KubeVersion.GitVersion -}}
networking.k8s.io/v1beta1
{{- else -}}
extensions/v1beta1
{{- end -}}
{{- end }}

{{/*
Render image reference
*/}}
{{- define "universal-app.image" -}}
{{- $tag := .tag | default $.Chart.AppVersion | toString -}}
{{- if .registry -}}
{{- printf "%s/%s:%s" .registry .repository $tag -}}
{{- else -}}
{{- printf "%s:%s" .repository $tag -}}
{{- end -}}
{{- end }}

{{/*
Return true if a configmap object should be created
*/}}
{{- define "universal-app.createConfigMap" -}}
{{- if .Values.configMaps }}
{{- true -}}
{{- end -}}
{{- end }}

{{/*
Return true if a secret object should be created
*/}}
{{- define "universal-app.createSecret" -}}
{{- if .Values.secrets }}
{{- true -}}
{{- end -}}
{{- end }}

{{/*
Renders a value that contains template.
Usage:
{{ include "universal-app.tplvalues.render" ( dict "value" .Values.path.to.the.Value "context" $) }}
*/}}
{{- define "universal-app.tplvalues.render" -}}
{{- if typeIs "string" .value }}
{{- tpl .value .context }}
{{- else }}
{{- tpl (.value | toYaml) .context }}
{{- end }}
{{- end }}

{{/*
Pod template specification - shared across Deployment, DaemonSet, and StatefulSet
*/}}
{{- define "universal-app.podTemplate" -}}
metadata:
  labels:
    {{- include "universal-app.selectorLabels" . | nindent 4 }}
    {{- with .Values.podLabels }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
  {{- with .Values.podAnnotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
spec:
  {{- with .Values.imagePullSecrets }}
  imagePullSecrets:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  serviceAccountName: {{ include "universal-app.serviceAccountName" . }}
  {{- with .Values.podSecurityContext }}
  securityContext:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- if .Values.terminationGracePeriodSeconds }}
  terminationGracePeriodSeconds: {{ .Values.terminationGracePeriodSeconds }}
  {{- end }}
  {{- if .Values.dnsPolicy }}
  dnsPolicy: {{ .Values.dnsPolicy }}
  {{- end }}
  {{- if .Values.restartPolicy }}
  restartPolicy: {{ .Values.restartPolicy }}
  {{- end }}
  {{- if .Values.hostNetwork }}
  hostNetwork: {{ .Values.hostNetwork }}
  {{- end }}
  {{- if .Values.hostPID }}
  hostPID: {{ .Values.hostPID }}
  {{- end }}
  {{- if .Values.hostIPC }}
  hostIPC: {{ .Values.hostIPC }}
  {{- end }}
  {{- if .Values.shareProcessNamespace }}
  shareProcessNamespace: {{ .Values.shareProcessNamespace }}
  {{- end }}
  {{- if .Values.priorityClassName }}
  priorityClassName: {{ .Values.priorityClassName }}
  {{- end }}
  {{- if .Values.runtimeClassName }}
  runtimeClassName: {{ .Values.runtimeClassName }}
  {{- end }}
  enableServiceLinks: {{ .Values.enableServiceLinks }}
  {{- with .Values.hostAliases }}
  hostAliases:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .Values.dnsConfig }}
  dnsConfig:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .Values.nodeSelector }}
  nodeSelector:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .Values.tolerations }}
  tolerations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .Values.affinity }}
  affinity:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .Values.topologySpreadConstraints }}
  topologySpreadConstraints:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- if .Values.initContainers }}
  initContainers:
    {{- include "universal-app.renderContainers" (dict "containers" .Values.initContainers "context" .) | nindent 4 }}
  {{- end }}
  containers:
    {{- if .Values.containers }}
    {{- include "universal-app.renderContainers" (dict "containers" .Values.containers "context" .) | nindent 4 }}
    {{- else }}
    {{- include "universal-app.renderLegacyContainer" . | nindent 4 }}
    {{- end }}
    {{- if .Values.sidecarContainers }}
    {{- include "universal-app.renderContainers" (dict "containers" .Values.sidecarContainers "context" .) | nindent 4 }}
    {{- end }}
  {{- with .Values.volumes }}
  volumes:
    {{- toYaml . | nindent 4 }}
  {{- end }}
{{- end }}

{{/*
Render multiple containers
*/}}
{{- define "universal-app.renderContainers" -}}
{{- range .containers }}
- name: {{ .name }}
  image: "{{ .image.repository }}:{{ .image.tag }}"
  {{- if .image.pullPolicy }}
  imagePullPolicy: {{ .image.pullPolicy }}
  {{- end }}
  {{- with .ports }}
  ports:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .env }}
  env:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .envFrom }}
  envFrom:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .resources }}
  resources:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .volumeMounts }}
  volumeMounts:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .livenessProbe }}
  livenessProbe:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .readinessProbe }}
  readinessProbe:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .startupProbe }}
  startupProbe:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .securityContext }}
  securityContext:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .lifecycle }}
  lifecycle:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .command }}
  command:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .args }}
  args:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- if .workingDir }}
  workingDir: {{ .workingDir }}
  {{- end }}
  {{- if .stdin }}
  stdin: {{ .stdin }}
  {{- end }}
  {{- if .stdinOnce }}
  stdinOnce: {{ .stdinOnce }}
  {{- end }}
  {{- if .tty }}
  tty: {{ .tty }}
  {{- end }}
{{- end }}
{{- end }}

{{/*
Render legacy single container (backward compatibility)
*/}}
{{- define "universal-app.renderLegacyContainer" -}}
- name: {{ .Values.containerName }}
  image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
  imagePullPolicy: {{ .Values.image.pullPolicy }}
  {{- with .Values.containerPorts }}
  ports:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .Values.env }}
  env:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .Values.envFrom }}
  envFrom:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .Values.resources }}
  resources:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .Values.volumeMounts }}
  volumeMounts:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .Values.livenessProbe }}
  livenessProbe:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .Values.readinessProbe }}
  readinessProbe:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .Values.startupProbe }}
  startupProbe:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .Values.containerSecurityContext }}
  securityContext:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .Values.lifecycle }}
  lifecycle:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .Values.command }}
  command:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .Values.args }}
  args:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- if .Values.workingDir }}
  workingDir: {{ .Values.workingDir }}
  {{- end }}
  {{- if .Values.stdin }}
  stdin: {{ .Values.stdin }}
  {{- end }}
  {{- if .Values.stdinOnce }}
  stdinOnce: {{ .Values.stdinOnce }}
  {{- end }}
  {{- if .Values.tty }}
  tty: {{ .Values.tty }}
  {{- end }}
{{- end }}