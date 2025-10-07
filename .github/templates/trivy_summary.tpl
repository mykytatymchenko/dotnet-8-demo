{{- $crit := 0 -}}{{- $high := 0 -}}{{- $med := 0 -}}{{- $low := 0 -}}{{- $unk := 0 -}}
{{- $mcrit := 0 -}}{{- $mhigh := 0 -}}{{- $mmed := 0 -}}{{- $mlow := 0 -}}{{- $munk := 0 -}}
{{- $secrets := 0 -}}{{- $targets := 0 -}}

{{- /* Iterate over results at root (types.Results) */ -}}
{{- range . }}
  {{- $targets = add $targets 1 -}}
  {{- range .Vulnerabilities }}
    {{- if eq .Severity "CRITICAL" }}{{ $crit = add $crit 1 }}{{ end -}}
    {{- if eq .Severity "HIGH"     }}{{ $high = add $high 1 }}{{ end -}}
    {{- if eq .Severity "MEDIUM"   }}{{ $med  = add $med  1 }}{{ end -}}
    {{- if eq .Severity "LOW"      }}{{ $low  = add $low  1 }}{{ end -}}
    {{- if eq .Severity "UNKNOWN"  }}{{ $unk  = add $unk  1 }}{{ end -}}
  {{- end }}
  {{- range .Misconfigurations }}
    {{- if eq .Severity "CRITICAL" }}{{ $mcrit = add $mcrit 1 }}{{ end -}}
    {{- if eq .Severity "HIGH"     }}{{ $mhigh = add $mhigh 1 }}{{ end -}}
    {{- if eq .Severity "MEDIUM"   }}{{ $mmed  = add $mmed  1 }}{{ end -}}
    {{- if eq .Severity "LOW"      }}{{ $mlow  = add $mlow  1 }}{{ end -}}
    {{- if eq .Severity "UNKNOWN"  }}{{ $munk  = add $munk  1 }}{{ end -}}
  {{- end }}
  {{- $secrets = add $secrets (len .Secrets) -}}
{{- end }}

{{- $vtotal := add (add (add (add $crit $high) $med) $low) $unk -}}
{{- $mtotal := add (add (add (add $mcrit $mhigh) $mmed) $mlow) $munk -}}
{{- $total  := add (add $vtotal $mtotal) $secrets -}}

| Type | <span style="color:#cf222e;"><strong>CRITICAL</strong></span> | <span style="color:#d97706;"><strong>HIGH</strong></span> | <span style="color:#b88700;"><strong>MEDIUM</strong></span> | <span style="color:#0969da;"><strong>LOW</strong></span> | <span style="color:#57606a;"><strong>UNKNOWN</strong></span> | **TOTAL** |
|---|---:|---:|---:|---:|---:|---:|
| Vulnerabilities   | {{ $crit }} | {{ $high }} | {{ $med }} | {{ $low }} | {{ $unk }} | **{{ $vtotal }}** |
| Misconfigurations | {{ $mcrit }} | {{ $mhigh }} | {{ $mmed }} | {{ $mlow }} | {{ $munk }} | **{{ $mtotal }}** |

**Secrets:** {{ $secrets }} · **Targets:** {{ $targets }} · **Total findings:** **{{ $total }}**
