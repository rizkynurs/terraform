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

<<<<<<< HEAD
variable "elb_type" {
  description = "Map of ELB Type"
  type = map(object({
    id   = string
    type = string
    name = string
  }))
  default = {
    l4-small1 = {
      id   = "8d9b7d18-c699-49ed-bc86-8642e4f29844"
      type = "L4"
      name = "L4_flavor.elb.s1.small"
    }
    l4-small2 = {
      id   = "cd787b0c-225a-4a77-bb1f-86c3acbc4d36"
      type = "L4"
      name = "L4_flavor.elb.s2.small"
    }
    l4-medium1 = {
      id   = "04a74b31-3cd5-49ae-b178-b4be1ec5b2e3"
      type = "L4"
      name = "L4_flavor.elb.s1.medium"
    }
    l4-medium2 = {
      id   = "0ddcf45d-d80b-4a61-8bfa-1abdbc7b323d"
      type = "L4"
      name = "L4_flavor.elb.s2.medium"
    }
  }
=======
variable "subnet" {
  description = "Set Subnet for Instance"
  type = string
  default = "1236f2d0" #subnet-datacore-services
>>>>>>> 85260d0284ed7cde7f4b4775f9345a6716e59de5
}

variable "create_eip" {
  description = "Whether to create an Elastic IP for the Load Balancer"
  type        = bool
  default     = false  # Set to true if you want to create an EIP
}