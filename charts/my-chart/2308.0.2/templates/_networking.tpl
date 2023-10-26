{{/*
DNS Configuration
*/}}
{{- define "dnsConfiguration" }}
dnsPolicy: {{ .Values.dnsPolicy }}
{{- if .Values.dnsConfig }}
dnsConfig:
  {{- toYaml .Values.dnsConfig | nindent 2 }}
{{- end }}
{{- end }}

{{/*
Host Aliases
*/}}
{{- define "hostAliases" }}
{{- if .Values.hostAliases }}
hostAliases:
  {{- range .Values.hostAliases }}
  - ip: {{ .ip | quote }}
    hostnames: 
    - {{ .hostname | quote }}
  {{- end }}
{{- end }}
{{- end }}

{{- if .Values.hostname }}
{{/*
Hostname
*/}}
{{- define "hostname" }}
{{- if .Values.hostname.hostname }}
hostname: {{ . | quote }}
{{- end }}
{{- end }}

{{/*
Subdomian
*/}}
{{- define "subdomian" }}
{{- if .Values.hostname.subdomian }}
subdomian: {{ . | quote }}
{{- end }}
{{- end }}
{{- end }}


{{/*
Get configuration for host network
*/}}
{{- define "hostNetworkingConfiguration" -}}
{{- $host := default false .Values.hostNetwork -}}
{{- if or .Values.externalInterfaces (eq $host false) -}}
{{- print "false" -}}
{{- else -}}
{{- print "true" -}}
{{- end -}}
{{- end -}}

{{/* Validate portal port */}}
{{- if .Values.enableUIPortal }}
  {{- if and (not .Values.hostNetwork) (lt .Values.portalDetails.port 9000) }}
    {{- fail (printf "Port (%d) is too low. Minimum allowed port is 9000." .Values.portalDetails.port) }}
  {{- end }}
{{- end }}