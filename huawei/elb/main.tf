provider "huaweicloud" {
  region     = var.region
  access_key = var.accesskey
  secret_key = var.seckey
}

# Get existing instances by exact names
data "huaweicloud_compute_instances" "app_instances" {
  #name = "test-rock*"  # Matches both instance names
  name                = "^test-rocky.*"
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

data "huaweicloud_elb_flavors" "l4_flavors" {
  type = "L4"
  name = "L4_flavor.elb.s1.small"  # Replace with your actual flavor name
#   shared = "true"
#   flavor_sold_out = "false"
}

resource "huaweicloud_vpc_bandwidth" "bandwidth_1" {
  name = "bandwidth_1"
  charge_mode = "bandwidth"  # Satisfy API requirement
  size        = 5          # No actual bandwidth use
  enterprise_project_id = var.project["core-service"].id
}

# Create internal Network Load Balancer (Layer 4)
resource "huaweicloud_elb_loadbalancer" "elb" {
  name                  = "internal-elb"
  iptype                = "FIXED"
  vpc_id                = data.huaweicloud_vpc.vpc.id
  ipv4_subnet_id        = data.huaweicloud_vpc_subnet.frontend_subnet.ipv4_subnet_id
  ipv4_address          = "10.250.0.99"
  availability_zone     = ["ap-southeast-4a"]
  bandwidth_id          = huaweicloud_vpc_bandwidth.bandwidth_1.id
  l4_flavor_id          = data.huaweicloud_elb_flavors.l4_flavors.flavors[0].id
#  l4_flavor_id          = "8d9b7d18-c699-49ed-bc86-8642e4f29844"
#   l4_flavor_id          = data.huaweicloud_elb_flavors.l4_flavors.flavors[*].id

  enterprise_project_id = var.project["core-service"].id

  tags = {
    ip-db-collector = "ip-db-collector"
  }
}

# Backend pools
resource "huaweicloud_elb_pool" "pool_80" {
  name            = "tcp-80-pool"
  protocol        = "TCP"
  lb_method       = "ROUND_ROBIN"
  loadbalancer_id = huaweicloud_elb_loadbalancer.elb.id
}

resource "huaweicloud_elb_pool" "pool_443" {
  name            = "tcp-443-pool"
  protocol        = "TCP"
  lb_method       = "ROUND_ROBIN"
  loadbalancer_id = huaweicloud_elb_loadbalancer.elb.id
}

# Listeners
resource "huaweicloud_elb_listener" "http" {
  name            = "listeners-80"
  protocol        = "TCP"
  protocol_port   = 80
  loadbalancer_id = huaweicloud_elb_loadbalancer.elb.id
  default_pool_id = huaweicloud_elb_pool.pool_80.id
}

resource "huaweicloud_elb_listener" "https" {
  name            = "listeners-443"
  protocol        = "TCP"
  protocol_port   = 443
  loadbalancer_id = huaweicloud_elb_loadbalancer.elb.id
  default_pool_id = huaweicloud_elb_pool.pool_443.id
}

# Add instances to both pools
resource "huaweicloud_elb_member" "http_members" {
  for_each = { 
    for instance in data.huaweicloud_compute_instances.app_instances.instances : 
    instance.id => instance 
  }

  address        = each.value.network[0].fixed_ip_v4
  protocol_port  = 80
  pool_id        = huaweicloud_elb_pool.pool_80.id
  subnet_id      = data.huaweicloud_vpc_subnet.backend_subnet.id
}

resource "huaweicloud_elb_member" "https_members" {
  for_each = { 
    for instance in data.huaweicloud_compute_instances.app_instances.instances : 
    instance.id => instance 
  }

  address        = each.value.network[0].fixed_ip_v4
  protocol_port  = 443
  pool_id        = huaweicloud_elb_pool.pool_443.id
  subnet_id      = data.huaweicloud_vpc_subnet.backend_subnet.id
}

output "all_l4_flavors" {
  value = data.huaweicloud_elb_flavors.l4_flavors.flavors
}