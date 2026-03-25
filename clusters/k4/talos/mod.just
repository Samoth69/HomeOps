set positional-arguments := true
set quiet := true
set shell := ['zsh', '-cu']

talos_dir := source_directory()
controller := `talosctl config info -o yaml | yq -e '.endpoints[0]'`
nodes := `talosctl config info -o yaml | yq -e '.nodes | join (",")'`

[private]
default:
    just -l clusters k4 talos

[doc('Apply Talos config to a node')]
apply-node node *args:
    just log info "Applying Talos machineconfig" "node" "{{ node }}";
    just clusters k4 talos render-config "{{ node }}" | talosctl -n "{{ node }}" apply-config -f /dev/stdin {{ args }}

[doc('Apply Talos config to all nodes in the cluster')]
apply-cluster *args:
    kubectl get nodes --no-headers | while read -r node _; do \
      just clusters k4 talos apply-node ${node} {{ args }}; \
    done

[doc('Generate schematic ID from Talos schematic')]
gen-schematic-id:
    curl -sX POST --data-binary "@{{ talos_dir }}/schematic.yaml" "https://factory.talos.dev/schematics" | jq -r '.id'

[doc('Render Talos config for a node')]
render-config node:
    export IS_CONTROLPLANE="$(just clusters k4 talos machine-controller {{ node }})"; \
    sops decrypt "{{ talos_dir }}/talsecrets.sops.yaml" | yq '.. | select((tag == "!!map" or tag == "!!seq") | not) | "TALSECRET_" + (path | join("_") | upcase) + "=" + .' | while read p; do \
      export $p; \
    done; \
    talosctl machineconfig patch <(just template "{{ talos_dir }}/machineconfig.yaml.j2") \
      -p @<(just template "{{ talos_dir }}/nodes/{{ node }}.yaml.j2")

[doc('Reboot a node')]
reboot-node node:
    gum confirm "Reboot node {{ node }}?" && \
      talosctl -n {{ node }} reboot -m powercycle || exit 0

[doc('Reset a node')]
reset-node node mode="reboot":
    gum confirm "Reset node {{ node }}?" && \
      talosctl -e "{{ node }}" -n "{{ node }}" reset --system-labels-to-wipe STATE --system-labels-to-wipe EPHEMERAL --system-labels-to-wipe u-hostpath-data --graceful=false {{ if mode == "reboot" { "--reboot" } else { "" } }} || exit 0

[doc('Reset all nodes in the cluster')]
reset-cluster mode="reboot":
    gum confirm "Reset cluster ?" && \
      just clusters k4 talos reset-node {{ nodes }} {{ mode }};

[doc('Upgrade Kubernetes version on the cluster')]
upgrade-k8s version:
    talosctl -n "{{ controller }}" upgrade-k8s --to {{ version }}

[doc('Upgrade Talos version on a node')]
upgrade-node node:
    talosctl -n "{{ node }}" upgrade -i "$(just clusters k4 talos machine-image {{ node }})" -m powercycle --timeout=10m

[doc('Download Talos machine image')]
download-image version schematic:
    gum spin --title "Downloading Talos {{ version }} ..." -- \
    curl -sfL --remove-on-error --retry 5 --retry-delay 5 --retry-all-errors \
        -o "{{ talos_dir }}/talos-{{ version }}-{{ replace_regex(schematic, '^(.{8}).*', '$1') }}.iso" \
        "https://factory.talos.dev/image/{{ schematic }}/{{ version }}/metal-amd64.iso"
    just log info "Downloaded Talos" version "{{ version }}" schematic "{{ schematic }}"

[doc('Output talos config file')]
build-talos-config:
    talosctl gen config --with-secrets <(sops decrypt talsecrets.sops.yaml) k4 https://192.168.0.35:6443 -o talconfig.yaml -t talosconfig

[private]
machine-controller node:
    just template "{{ talos_dir }}/nodes/{{ node }}.yaml.j2" | yq -e 'select(.machine) | (.machine.type == "controlplane") // ""'

[doc('Get the machine image for a given node')]
[private]
machine-image node:
    talosctl --nodes {{ node }} get machineconfig -o yaml | yq -e 'select(.metadata.id == "v1alpha1") | .spec' | yq -e 'select(.machine) | .machine.install.image'