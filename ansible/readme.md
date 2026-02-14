# Infrastructure As Code (IAC)

Ansible powered, run from windows WSL.  

```bash
ansible-galaxy install gantsign.oh-my-zsh
ansible-galaxy install linux-system-roles.kernel_settings
ansible-galaxy collection install -U community.docker
ansible-galaxy collection install -U ansible.posix
ansible-galaxy collection install -U devsec.hardening
```

# machinectl

Pour avoir bien une session dbus liée et tout qui va bien faut taper ça :

```bash
machinectl shell podboy@
```