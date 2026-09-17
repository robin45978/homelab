
# OpenTofu – Infrastructure as Code (Terraform-compatible)

## Files

* `main.tf` – Defines the infrastructure.
* `terraform.tfvars` – Contains variable values. This file is excluded via `.gitignore` to prevent sensitive data from being committed.

## Usage

Initialize the OpenTofu working directory:

```bash
tofu init
```

Preview infrastructure changes:

```bash
tofu plan
```

Apply the configuration:

```bash
tofu apply
```
