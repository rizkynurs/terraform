# output "vm_ids" {
#   description = "List of VM instance IDs"
#   value       = { for key, vm in huaweicloud_compute_instance.vm : key => vm.id }
# }

# output "vm_names" {
#   description = "List of VM names"
#   value       = [for vm in huaweicloud_compute_instance.vm : vm.name]
# }

# output "vm_private_ips" {
#   description = "Private IP addresses of the VMs"
#   value       = huaweicloud_compute_instance.vm[*].network[0].fixed_ip_v4
# }

output "instances" {
  value = {
    for instance in huaweicloud_compute_instance.vm[*] :
    instance.name => {
      id          = instance.id
      ipv4        = instance.network[0].fixed_ip_v4
      flavor_name = instance.flavor_id
      # Add more fields as needed (e.g., status, flavor)
    }
  }
  description = "Details of instances including name and IPv4 address."
}

output "volume_ids" {
  description = "List of attached volume IDs"
  value       = { for key, vol in huaweicloud_evs_volume.disk : key => vol.id }
}

output "security_group" {
  # value = data.huaweicloud_networking_secgroup.mysecgroup.name
  value = var.secgroup["sg-core-service"].name
}

output "subnet" {
  value = data.huaweicloud_vpc_subnet.mynet.name
}

output "enterprise_project" {
  value = var.project["core-service"].name
}