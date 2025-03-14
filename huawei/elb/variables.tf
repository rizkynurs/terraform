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
      id   = "79f110fd-aabd-4817-ae2a-b76c0f3410d5"
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
      id   = "5af06008-6382-46bd-a1df-c9df052d6915"
      name = "sg-core-service"
    }
  }
}

variable "subnet" {
  description = "Set Subnet for Instance"
  type = string
  default = "1236f2d0-6750-42b0-b996-4334ed7f3941" #subnet-datacore-services
}

variable "create_eip" {
  description = "Whether to create an Elastic IP for the Load Balancer"
  type        = bool
  default     = false  # Set to true if you want to create an EIP
}
