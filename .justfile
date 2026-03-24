#!/usr/bin/env -S just --justfile

set shell := ['zsh', '-cu']
set quiet := true

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
