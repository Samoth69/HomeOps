set positional-arguments := true
set quiet := true
set shell := ['zsh', '-cu']

kubernetes_dir := source_directory()

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

[doc('Create a backup of the database')]
backup-database:
    kubectl cnpg backup -n database postgres --method=plugin --plugin-name=barman-cloud.cloudnative-pg.io

[doc('Push current repo to Garage')]
garage-sync:
    sops decrypt "{{ kubernetes_dir }}/rclone.sops.yaml" | yq '.stringData | map(key + "=" + .)[]' | while read p; do \
      export $p; \
    done; \
    rclone sync --fast-list --checksum --s3-env-auth --s3-region garage --s3-force-path-style "{{ kubernetes_dir }}" :s3:k4-fluxcd/clusters/k4/kubernetes