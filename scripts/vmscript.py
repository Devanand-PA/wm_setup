#!/bin/python3
import os
import subprocess
import sys
sel_vm = subprocess.check_output("ls ~/Qemu/VMs/*/*.vm | dmenu -l 20",shell=True).decode("utf-8").rstrip()
uefi = []
if "uefi" in sel_vm :
    uefi = ["-bios", "/usr/share/ovmf/OVMF.fd"]
architecture = os.path.basename(os.path.dirname(sel_vm))
net = []
qemu_command = ['qemu-system-'+architecture]
vdisks = [ sel_vm ]
graphics = ["-device", "virtio-vga-gl" ,"-display" ,"gtk,gl=on,full-screen=on"]
memory = ["-m","4G"]
optimizations = ["-enable-kvm","-smp","8","-cpu","host"]
audio = ["-device","intel-hda"]
audio = ["-device","AC97"]
cdrom = []
if "-c" in sys.argv :
    cdrom = [ "-cdrom" , sys.argv[sys.argv.index("-c")+1] ]

#qemu-system-x86_64  $VM -device virtio-vga-gl -display gtk,gl=on,full-screen=on -m 4G -enable-kvm -smp 8 -cpu host  -device intel-hda
final_command = qemu_command + vdisks + net + cdrom + graphics + memory + optimizations + audio + uefi
subprocess.run(final_command)
