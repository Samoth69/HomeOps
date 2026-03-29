set positional-arguments := true
set quiet := true
set shell := ['zsh', '-cu']

kubernetes_dir := justfile_dir()

[private]
default:
    just -l clusters k4 kubernetes

[doc("Prune pods inside cluster")]
prune-pods:
    for phase in Failed Pending Succeeded; do \
        kubectl delete pods -A --field-selector status.phase="$phase" --ignore-not-found=true; \
    done

[doc('Sync single Flux HelmRelease')]
sync-hr ns name:
    kubectl -n "{{ ns }}" annotate --field-manager flux-client-side-apply --overwrite hr "{{ name }}" reconcile.fluxcd.io/requestedAt="$(date +%s)" reconcile.fluxcd.io/forceAt="$(date +%s)"; \

[doc('Sync single Flux Kustomizations')]
sync-ks ns name:
    kubectl -n "{{ ns }}" annotate --field-manager flux-client-side-apply --overwrite ks "{{ name }}" reconcile.fluxcd.io/requestedAt="$(date +%s)"; \

[doc('Browse a PVC')]
browse-pvc namespace claim:
    kubectl browse-pvc -n {{ namespace }} -i mirror.gcr.io/alpine:latest {{ claim }}