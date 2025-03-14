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
  default = "1236f2d0" #subnet-datacore-services
}

variable "create_eip" {
  description = "Whether to create an Elastic IP for the Load Balancer"
  type        = bool
  default     = false  # Set to true if you want to create an EIP
}
