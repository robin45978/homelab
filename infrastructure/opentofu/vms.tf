
# VM 113 - Docker
resource "proxmox_virtual_environment_vm" "docker" {
  node_name = "pve-elt-01"
  vm_id     = 113

  name    = "Docker"
  on_boot = true

  boot_order = [
    "scsi0",
    "net0"
  ]

  scsi_hardware = "virtio-scsi-single"

  cpu {
    cores   = 2
    sockets = 1
    type    = "x86-64-v2-AES"
    numa    = false
  }

  memory {
    dedicated = 4000
  }

  disk {
    interface    = "scsi0"
    datastore_id = "local-zfs"
    size         = 50
    iothread     = true
  }

  network_device {
    bridge      = "vmbr0"
    model       = "virtio"
    mac_address = "BC:24:11:5D:B4:12"
    vlan_id     = 20
  }

  operating_system {
    type = "l26"
  }
}


