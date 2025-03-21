# Zone Region
data "huaweicloud_availability_zones" "az1" {}

# Flavors (CPU & RAM)
# data "huaweicloud_compute_flavors" "myflavor" {
#   availability_zone = data.huaweicloud_availability_zones.az1.names[0]
#   performance_type  = "normal"
#   cpu_core_count    = var.flavor_cpu
#   memory_size       = var.flavor_memory
# }

# Subnet
data "huaweicloud_vpc_subnet" "mynet" {
  name = var.subnet_name
}

# VM Instance Resource
resource "huaweicloud_compute_instance" "vm" {
  count              = 2
  name               = "test-centos0${count.index + 3}"
  image_id           = var.huaweicloud_images["centos"].id
  flavor_id          = "s7n.small.1" #1 cpu 1gb memory, for more detail check on https://support.huaweicloud.com/intl/en-us/productdesc-ecs/ecs_01_0014.html
  availability_zone  = data.huaweicloud_availability_zones.az1.names[0]
  security_group_ids = [var.secgroup["sg-core-service"].id]
  admin_pass         = var.admin_pass
  system_disk_type   = "SAS"
  system_disk_size   = var.disk_size

  network {
    uuid = data.huaweicloud_vpc_subnet.mynet.id
    fixed_ip_v4 = "10.250.0.8${count.index + 7}" #mulai dari 0.87
  }

  tags = {
    ip-db-collector = "ip-db-collector"
  }

  enterprise_project_id = var.project["core-service"].id
}

# Adding an EVS Disk 
resource "huaweicloud_evs_volume" "disk" {
  count             = 2  # Match the VM count
  name              = "disk-test-centos0${count.index + 3}"
  availability_zone = data.huaweicloud_availability_zones.az1.names[0]
  volume_type       = "SAS"
  size              = var.extra_disk_size
  server_id         = huaweicloud_compute_instance.vm[count.index].id  # Use index
}

# resource "huaweicloud_compute_volume_attach" "attach_disk" {
#   for_each    = var.vm_configs
#   instance_id = huaweicloud_compute_instance.vm[each.key].id
#   volume_id   = huaweicloud_evs_volume.disk[each.key].id
# }