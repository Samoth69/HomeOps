set quiet := true

mod bootstrap
mod talos

[private]
default:
    just -l clusters k4

[doc("Prune pods inside cluster")]
prune-pods:
    for phase in Failed Pending Succeeded; do \
        kubectl delete pods -A --field-selector status.phase="$phase" --ignore-not-found=true; \
    done