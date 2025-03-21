# output "all_l4_flavors" {
#   value = data.huaweicloud_elb_flavors.l4_flavors.flavors
# }

output "instances" {
  value = {
    for instance in data.huaweicloud_compute_instances.app_instances.instances :
    instance.id => {
      name       = instance.name
      ipv4       = instance.network[0].fixed_ip_v4
      # Add more fields as needed (e.g., status, flavor)
    }
  }
  description = "Details of instances including name and IPv4 address."
}

output "vpc-name" {
  value = data.huaweicloud_vpc.vpc.name
}

output "backend_subnet" {
  value = data.huaweicloud_vpc_subnet.backend_subnet.name
}

output "frontend_subnet" {
  value = data.huaweicloud_vpc_subnet.frontend_subnet.name
}

output "ipv4" {
  value = huaweicloud_elb_loadbalancer.elb.ipv4_address
}