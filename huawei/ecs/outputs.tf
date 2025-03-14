output "ID" {
  value = huaweicloud_compute_instance.instances.id
}

output "name" {
  value = huaweicloud_compute_instance.instances.name
}

output "network" {
  #value = huaweicloud_compute_instance.instances.fixed_ip_v4 #.network -> version 1.20
  value = huaweicloud_compute_instance.instances.network[0].fixed_ip_v4
  description = "The network details of the VM instance"
}