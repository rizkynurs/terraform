# Configure the HUAWEI CLOUD provider.
provider "huaweicloud" {
  region     = "ap-southeast-4"
  access_key = "SAXBL"
  secret_key = "1HKMR"
}

# Define Zone Region
data "huaweicloud_availability_zones" "az1" {}

data "huaweicloud_compute_flavors" "myflavor" {
  availability_zone = data.huaweicloud_availability_zones.az1.names[0]
  performance_type  = "normal"
  cpu_core_count    = 1
  memory_size       = 2
}

# Define Subnet
data "huaweicloud_vpc_subnet" "mynet" {
  name = "subnet-datacore-service"
}

# Define Image
data "huaweicloud_images_image" "myimage" {
  name        = "Rocky Linux 8.8 64bit"
  most_recent = true
}

# Define Security Group
data "huaweicloud_networking_secgroup" "mysecgroup" {
  name = "sg-core-service"
}

# Define Enterprise Project
data "huaweicloud_enterprise_project" "myproject" {
  name = "core-service"
}

# Create a VM Instances
resource "huaweicloud_compute_instance" "test-terraform" {
  name               = "test-terraform"
  image_id           = data.huaweicloud_images_image.myimage.id
  flavor_id          = data.huaweicloud_compute_flavors.myflavor.ids[0]
  availability_zone  = data.huaweicloud_availability_zones.az1.names[0]
  security_group_ids = [data.huaweicloud_networking_secgroup.mysecgroup.id]
  admin_pass         = "4ipbb-c0ll3ct0R#@"
  system_disk_type   = "SAS"
  system_disk_size   = 50

  network {
    uuid = data.huaweicloud_vpc_subnet.mynet.id
  }

  tags = {
    ip-db-collector = "ip-db-collector"
  }

  enterprise_project_id = data.huaweicloud_enterprise_project.myproject.id
}

# Adding an EVS Disk
resource "huaweicloud_evs_volume" "test-terraform-diskB" {
  name              = "test-terraform-diskB"
  availability_zone = data.huaweicloud_availability_zones.az1.names[0]
  volume_type       = "SAS"
  size              = 10
}

resource "huaweicloud_evs_volume" "test-terraform-diskC" {
  name              = "test-terraform-diskC"
  availability_zone = data.huaweicloud_availability_zones.az1.names[0]
  volume_type       = "SAS"
  size              = 10
}

resource "huaweicloud_compute_volume_attach" "attached_disk_1" {
  instance_id = huaweicloud_compute_instance.test-terraform.id
  volume_id   = huaweicloud_evs_volume.test-terraform-diskB.id
}

resource "huaweicloud_compute_volume_attach" "attached_disk_2" {
  instance_id = huaweicloud_compute_instance.test-terraform.id
  volume_id   = huaweicloud_evs_volume.test-terraform-diskC.id
}