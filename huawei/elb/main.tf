# Get existing instances by exact names
data "huaweicloud_compute_instances" "app_instances" {
  #name = "test-rock*"  # Matches both instance names
  name                = "^test-centos0.*"
  enterprise_project_id = var.project["core-service"].id
}

# Get network details
data "huaweicloud_vpc" "vpc" {
  name = "vpc-core-service"
}

# Frontend Subnet (for Load Balancer VIP)
data "huaweicloud_vpc_subnet" "frontend_subnet" {
  name   = "subnet-datacore-service"  # Your frontend subnet name
  vpc_id = data.huaweicloud_vpc.vpc.id
}

# Backend Subnet (for instances)
data "huaweicloud_vpc_subnet" "backend_subnet" {
  name   = "subnet-datacore-service"  # Your backend subnet name
  vpc_id = data.huaweicloud_vpc.vpc.id
}

# resource "huaweicloud_vpc_bandwidth" "bandwidth_1" {
#   name = "bandwidth_1"
#   charge_mode = "bandwidth"  # Satisfy API requirement
#   size        = 5          # No actual bandwidth use
#   enterprise_project_id = var.project["core-service"].id
# }


# Create internal Network Load Balancer (Layer 4)
resource "huaweicloud_elb_loadbalancer" "elb" {
  name                  = "elb-test-centos"
  # iptype                = "internal"
  vpc_id                = data.huaweicloud_vpc.vpc.id
  ipv4_subnet_id        = data.huaweicloud_vpc_subnet.frontend_subnet.ipv4_subnet_id
  ipv4_address          = "10.250.0.90"
  availability_zone     = ["ap-southeast-4a"] #az1
  # bandwidth_id          = "2e4f71cb-1786-43e9-b90a-8dee69d0b743"
  l4_flavor_id          = var.elb_type["l4-small1"].id

  enterprise_project_id = var.project["core-service"].id

  tags = {
    elb = "test-centos"
  }
}

# Listeners
resource "huaweicloud_elb_listener" "http" { #backend server
  name            = "listeners-80"
  protocol        = "TCP"
  protocol_port   = 80
  loadbalancer_id = huaweicloud_elb_loadbalancer.elb.id
  default_pool_id = huaweicloud_elb_pool.pool_80.id
}

resource "huaweicloud_elb_listener" "https" { #backend server
  name            = "listeners-443"
  protocol        = "TCP"
  protocol_port   = 443
  loadbalancer_id = huaweicloud_elb_loadbalancer.elb.id
  default_pool_id = huaweicloud_elb_pool.pool_443.id
}

# Pools with explicit dependency on listeners
resource "huaweicloud_elb_pool" "pool_80" { #backend server
  name            = "tcp-80-pool"
  protocol        = "TCP"
  lb_method       = "ROUND_ROBIN"
  loadbalancer_id = huaweicloud_elb_loadbalancer.elb.id
  deletion_protection_enable = false

  # lifecycle {
  #   replace_triggered_by = [huaweicloud_elb_listener.http]
  # }
}

resource "huaweicloud_elb_pool" "pool_443" {
  name            = "tcp-443-pool"
  protocol        = "TCP"
  lb_method       = "ROUND_ROBIN"
  loadbalancer_id = huaweicloud_elb_loadbalancer.elb.id
  deletion_protection_enable = false
}

resource "huaweicloud_elb_monitor" "monitor_pool_80" {
  pool_id              = huaweicloud_elb_pool.pool_80.id
  max_retries          = 3
  protocol             = "TCP"
  interval             = 5
  timeout              = 3
}

resource "huaweicloud_elb_monitor" "monitor_pool_443" {
  pool_id              = huaweicloud_elb_pool.pool_443.id
  max_retries          = 3
  protocol             = "TCP"
  interval             = 5
  timeout              = 3
}

resource "huaweicloud_elb_member" "http_members" {
  for_each = { 
    for instance in data.huaweicloud_compute_instances.app_instances.instances : 
    instance.id => instance 
  }

  address        = each.value.network[0].fixed_ip_v4
  protocol_port  = 80
  pool_id        = huaweicloud_elb_pool.pool_80.id
  weight         = 100
  subnet_id      = data.huaweicloud_vpc_subnet.backend_subnet.ipv4_subnet_id
}

resource "huaweicloud_elb_member" "https_members" {
  for_each = { 
    for instance in data.huaweicloud_compute_instances.app_instances.instances : 
    instance.id => instance 
  }

  address        = each.value.network[0].fixed_ip_v4
  protocol_port  = 443
  pool_id        = huaweicloud_elb_pool.pool_443.id
  weight         = 100
  subnet_id      = data.huaweicloud_vpc_subnet.backend_subnet.ipv4_subnet_id
}