variable "region" {
  type = string
  default = "ap-southeast-4"
}

variable "accesskey" {
  type = string
  default = ""
}

variable "seckey" {
  type = string
  default = ""
  sensitive = true
}

variable "name" {
  description = "Instances Name"
  type = string
  default = "test-rocky1103"
}

variable "pass" {
  type = string
  default = "4dm1n#890"
}

variable "huaweicloud_images" {
  description = "Map of available Huawei Cloud images"
  type = map(object({
    id   = string
    name = string
    most_recent = list(bool)
  }))
  default = {
    rocky = {
      id   = "0abdaa97-f700-403e-a52d-8330edb49ee1"
      name = "Rocky Linux 8.8 64bit"
      most_recent = [true] 
    },
    ubuntu = {
      id   = "c565aed0-5990-4b41-928a-9cca83217bbc"
      name = "Ubuntu 18.04 server 64bit"
      most_recent = [true] 
    },
    debian = {
      id   = "8cba5045-d714-4e71-8dc5-559f621e9676" 
      name = "Debian 12.0.0 64bit"
      most_recent = [true] 
    },
    centos = {
      id   = "c2b1d373-b68f-4f6c-8eb4-0d28e7c0fe7c" #CentOS 7.9 64bit
      name = "CentOS 7.9 64bit"
      most_recent = [true] 
    }
  }
}

variable "project" {
  description = "Map of Enterprise Project"
  type = map(object({
    id   = string
    name = string
  }))
  default = {
    core-service = {
      id   = "79f110fd"
      name = "core-service"
    }
  }
}

variable "secgroup" {
  description = "Map of Security Group"
  type = map(object({
    id   = string
    name = string
  }))
  default = {
    sg-core-service = {
      id   = "5af06008"
      name = "sg-core-service"
    }
  }
}

variable "subnet" {
  description = "Set Subnet for Instance"
  type = string
<<<<<<< HEAD
  default = "1236f2d0-6750-42b0-b996-4334ed7f3941" #subnet-datacore-services
}
=======
  default = "1236f2d0" #subnet-datacore-services
}
>>>>>>> 85260d0284ed7cde7f4b4775f9345a6716e59de5
