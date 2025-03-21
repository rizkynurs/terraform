# Configure the HUAWEI CLOUD provider.
provider "huaweicloud" {
  region     = var.region
  access_key = var.accesskey
  secret_key = var.seckey
}

# Define Zone Region
data "huaweicloud_availability_zones" "az1" {}

data "huaweicloud_compute_flavors" "myflavor" {
  availability_zone = data.huaweicloud_availability_zones.az1.names[0]
  performance_type  = "normal"
  cpu_core_count    = 1
  memory_size       = 2
}

# Create a VM Instances
resource "huaweicloud_compute_instance" "instances" {
  name               = var.name
  image_id           = var.huaweicloud_images["rocky"].id
  flavor_id          = data.huaweicloud_compute_flavors.myflavor.ids[0]
  availability_zone  = data.huaweicloud_availability_zones.az1.names[0]
  security_group_ids = [var.secgroup["sg-core-service"].id]
  admin_pass         = var.pass
  system_disk_type   = "SAS"
  system_disk_size   = 50

  network {
    uuid = var.subnet
    fixed_ip_v4 = "10.250.0.109"
  }

  tags = {
    ip-db-collector = "ip-db-collector"
  }

  enterprise_project_id = var.project["core-service"].id
}

# Adding an EVS Disk
resource "huaweicloud_evs_volume" "instance-diskB" {
  name              = "${var.name}-diskB"
  #name              = var.name + "-diskB" #for terraform 0.12 and later can use this command
  availability_zone = data.huaweicloud_availability_zones.az1.names[0]
  volume_type       = "SAS"
  size              = 10
}

resource "huaweicloud_evs_volume" "instance-diskC" {
  name              = "${var.name}-diskC"
  availability_zone = data.huaweicloud_availability_zones.az1.names[0]
  volume_type       = "SAS"
  size              = 10
}

resource "huaweicloud_compute_volume_attach" "attached_disk_1" {
  instance_id = huaweicloud_compute_instance.instances.id
  volume_id   = huaweicloud_evs_volume.instance-diskB.id
}

resource "huaweicloud_compute_volume_attach" "attached_disk_2" {
  instance_id = huaweicloud_compute_instance.instances.id
  volume_id   = huaweicloud_evs_volume.instance-diskC.id
}