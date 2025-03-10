# Terraform Commands Guide

This document provides instructions on how to use Terraform commands for initializing, planning, applying, and destroying infrastructure.

---

## Basic Commands

### Initialize Terraform
```bash
terraform init
```

### Plan Terraform Changes
```bash
terraform plan
```

### Apply Terraform Changes
```bash
terraform apply
```

### Destroy Terraform Infrastructure
```bash
terraform destroy
```

---

## Commands with Manual Variable Declaration

If the required variables are not declared in the `terraform.tfvars` file, use the following commands with manual variable assignment:

### Initialize Terraform
```bash
terraform init
```

### Plan Terraform Changes
```bash
terraform plan \
  -var="project_id=core-services-rnd" \
  -var="subnet=subnet-rnd-01" \
  -var="private_ip=172.16.4.13"
```

### Apply Terraform Changes
```bash
terraform apply \
  -var="project_id=core-services-rnd" \
  -var="subnet=subnet-rnd-01" \
  -var="private_ip=172.16.4.13"
```

### Destroy Terraform Infrastructure
```bash
terraform destroy \
  -var="project_id=core-services-rnd" \
  -var="subnet=subnet-rnd-01" \
  -var="private_ip=172.16.4.13"
