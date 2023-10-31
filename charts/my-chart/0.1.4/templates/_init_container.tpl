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
