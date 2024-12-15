pkg install -y qemu-utils qemu-common qemu-system-x86_64-headless
qemu-img create -f qcow2 alpine.img 20g
wget https://dl-cdn.alpinelinux.org/alpine/v3.15/releases/x86_64/alpine-virt-3.15.3-x86_64.iso