#!/bin/bash
# Script de inicialização (user_data) para adicionar chave SSH

# Adiciona a chave para o usuário root
mkdir -p /root/.ssh
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEkYJJOQvZ1cLr4nn4xSrlaBjBFgWatw5PMijpavAYaw hermes-permanent-key" >> /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys

# Adiciona a chave para qualquer outro usuário com diretório home (ex: ubuntu)
for user_home in /home/*; do
  if [ -d "$user_home" ]; then
    user=$(basename "$user_home")
    mkdir -p "$user_home/.ssh"
    echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEkYJJOQvZ1cLr4nn4xSrlaBjBFgWatw5PMijpavAYaw hermes-permanent-key" >> "$user_home/.ssh/authorized_keys"
    chmod 600 "$user_home/.ssh/authorized_keys"
    chown -R "$user:$user" "$user_home/.ssh"
  fi
done

# Atualização do sistema e instalação do KVM
echo "Iniciando atualização do sistema e instalação do KVM..."

if command -v apt-get &> /dev/null; then
    # Sistemas baseados em Debian/Ubuntu
    export DEBIAN_FRONTEND=noninteractive
    apt-get update -y
    apt-get upgrade -y
    apt-get install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virtinst
    systemctl enable --now libvirtd
elif command -v yum &> /dev/null; then
    # Sistemas baseados em RHEL/CentOS/Rocky
    yum update -y
    yum install -y qemu-kvm libvirt virt-install
    systemctl enable --now libvirtd
fi

echo "Processo de atualização e instalação do KVM finalizado."
