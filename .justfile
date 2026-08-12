#!/usr/bin/env -S just --justfile

set shell := ['zsh', '-cu']
set quiet := true

homeops_dir := justfile_dir()

mod clusters

[private]
default:
  just -l clusters
    
[private]
log lvl msg *args:
  gum log -t rfc3339 -s -l "{{ lvl }}" "{{ msg }}" {{ args }}

[private]
template file *args:
  minijinja-cli "{{ file }}" {{ args }}

[doc('Push the repo in zot')]
push-to-zot:
  flux push artifact oci://zot.truenas.samoth.eu/homelab/homeops:$(git rev-parse --short HEAD) --path "{{ homeops_dir }}" --source="$(git config --get remote.origin.url)" --revision="$(git branch --show-current)@sha1:$(git rev-parse HEAD)"
  flux tag artifact oci://zot.truenas.samoth.eu/homelab/homeops:$(git rev-parse --short HEAD) --tag latest