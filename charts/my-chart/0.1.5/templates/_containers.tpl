{{/*
Container Command
*/}}
{{- define "containerCommand" }}
{{- if .Values.containerCommand }}
command:
  {{- range .Values.containerCommand }}
  - {{ . | quote}}
  {{- end }}
{{- end }}
{{- end }}

{{/*
Container Args
*/}}
{{- define "containerArgs" }}
{{- if .Values.containerArgs }}
args:
  {{- range .Values.containerArgs }}
  - {{ . | quote}}
  {{- end }}
{{- end }}
{{- end }}

{{/*
Container Environment Variables
*/}}
{{- define "containerEnvVariables" }}
{{- if .Values.containerEnvironmentVariables }}
env:
  {{- range .Values.containerEnvironmentVariables }}
  - name: {{ .name | quote }}
    value: {{ .value | quote }}
  {{- end }}
{{- end }}
{{- end }}

{{/*
Container Liveness Probe
*/}}
{{- define "containerLivenssProbe" }}
{{- if .Values.livenessProbe }}
livenessProbe:
  exec:
    command:
      {{ toYaml .Values.livenessProbe.command | indent 16 }}
  initialDelaySeconds: {{ .Values.livenessProbe.initialDelaySeconds }}
  periodSeconds: {{ .Values.periodSeconds }}
{{- end }}
{{- end }}

{{/*
Container Ports
*/}}
{{- define "containerPorts" }}
{{- if or .Values.portForwardingList .Values.hostPortsList }}
ports:
  {{- range $index, $config := .Values.portForwardingList }}
  - containerPort: {{ $config.containerPort }}
  {{- end }}
  {{- range $index, $config := .Values.hostPortsList }}
  - containerPort: {{ $config.containerPort }}
    hostPort: {{ $config.hostPort }}
  {{- end }}
{{- end }}
{{- end }}

{{/*
Container Resource Configuration
*/}}
{{- define "containerResourceConfiguration" }}
{{- if .Values.gpuConfiguration }}
resources:
  limits:
    {{- toYaml .Values.gpuConfiguration | nindent 4 }}
{{- end }}
{{- end }}

{{/*
Container Working Dir
*/}}
{{- define "workingDir" }}
{{- if .Values.workingDir }}
workingDir: {{ .Values.workingDir.value | quote}}
{{- end }}
{{- end }}

{{/*
Init Container Command
*/}}
{{- define "initContainerCommand" }}
{{- if .Values.initContainerCommand }}
command:
  {{- range .Values.initContainerCommand }}
  - {{ . | quote}}
  {{- end }}
{{- end }}
{{- end }}

{{/*
Init Container Environment Variables
*/}}
{{- define "initContainerEnvVariables" }}
{{- if or .Values.initContainerEnvironmentVariables .Values.containerEnvironmentVariables }}
env:
  {{- if .Values.containerEnvironmentVariables }}
  {{- range .Values.containerEnvironmentVariables }}
  - name: {{ .name | quote }}
    value: {{ .value | quote }}
  {{- end }}
  {{- end }}
  {{- if .Values.initContainerEnvironmentVariables }}
  {{- range .Values.initContainerEnvironmentVariables }}
  - name: {{ .name | quote }}
    value: {{ .value | quote }}
  {{- end }}
  {{- end }}
{{- end }}
{{- end }}


{{/*
Init Container
*/}}
{{- define "initContainer" }}
{{- if .Values.enableInitContainer }}
initContainers:
- name: {{ .Chart.Name }}-init
  {{- include "volumeMountsConfiguration" . | indent 2}}
  securityContext:
    privileged: true
  image: "{{ .Values.initContainerImage.repository }}:{{ .Values.initContainerImage.tag | default "latest" }}"
  imagePullPolicy: {{ .Values.initContainerImage.pullPolicy }}
  {{- include "initContainerCommand" . | indent 2 }}
  {{- include "initContainerEnvVariables" . | indent 2 }}
  {{- include "workingDir" . | indent 2 }}
{{- end }}
{{- end }}

