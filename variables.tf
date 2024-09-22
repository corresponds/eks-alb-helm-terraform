variable "project" {
  description = "project_name"
  type        = string
  default     = "eks"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default = {
    "Project"     = "TerraformEKSWorkshop"
    "Environment" = "Development"
    "Owner"       = "gekas"
  }
}