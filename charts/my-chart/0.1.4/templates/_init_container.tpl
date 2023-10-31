{{/*
Init Container Command
*/}}
{{- define "initContainerCommand" }}
{{- if .Values.init.containerCommand }}
command:
  {{- range .Values.init.containerCommand }}
  - {{ . | quote}}
  {{- end }}
{{- end }}
{{- end }}

{{/*
Init Container Environment Variables
*/}}
{{- define "initContainerEnvVariables" }}
{{- if or .Values.init.containerEnvironmentVariables .Values.containerEnvironmentVariables }}
env:
  {{- if .Values.containerEnvironmentVariables }}
  {{- range .Values.containerEnvironmentVariables }}
  - name: {{ .name | quote }}
    value: {{ .value | quote }}
  {{- end }}
  {{- end }}
  {{- if .Values.init.containerEnvironmentVariables }}
  {{- range .Values.init.containerEnvironmentVariables }}
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
{{- if .Values.enableInit }}
initContainers:
- name: {{ .Chart.Name }}-init
  {{- include "volumeMountsConfiguration" . | indent 2}}
  securityContext:
    privileged: true
  image: "{{ .Values.init.image.repository }}:{{ .Values.init.image.tag | default "latest" }}"
  imagePullPolicy: {{ .Values.init.image.pullPolicy }}
  {{- include "initContainerCommand" . | indent 2 }}
  {{- include "initContainerEnvVariables" . | indent 2 }}
  {{- include "workingDir" . | indent 2 }}
{{- end }}
{{- end }}

