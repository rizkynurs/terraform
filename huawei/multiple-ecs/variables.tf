variable "region" {
  type        = string
  default     = "ap-southeast-4"
}

variable "access_key" {
  type        = string
  default     = ""
}

variable "secret_key" {
  type        = string
  default     = ""
  sensitive   = true
}

variable "flavor_cpu" {
  type        = number
  default     = 1
}

variable "flavor_memory" {
  type        = number
  default     = 2
}

variable "disk_size" {
  type        = number
  default     = 50
}

variable "extra_disk_size" {
  type        = number
  default     = 10
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

variable "admin_pass" {
  type        = string
  default     = "4ipbb-c0ll3ct0R#@"
}

variable "security_group_name" {
  type        = string
  default     = "sg-core-service"
}

variable "subnet_name" {
  type        = string
  default     = "subnet-datacore-service"
}

variable "ssh_key_name" {
  description = "The name of the SSH key pair"
  type        = string
  default     = "my-ssh-key"
}

variable "ssh_private_key_path" {
  description = "The path to the private SSH key"
  type        = string
  default     = "~/.ssh/id_rsa"
}