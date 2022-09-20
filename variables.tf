variable "github_repo" {
  description = "GitHub repository to grant access to assume a role via OIDC."
  type        = string
}

variable "github_environments" {
  description = "(Optional) Allow GitHub action to deploy to all (default) or to one of the environments in the list."
  type        = list(string)
  default     = ["*"]
}

variable "github_branches" {
  description = "List of github branches allowed for oidc subject claims."
  type        = list(string)
  default     = []
}

variable "role_name" {
  description = "(Optional) role name of the created role, if not provided the github_repo will be used to generate."
  type        = string
  default     = null
}

variable "prefix" {
  description = "(Optional) project prefix"
  type        = string
  default     = ""
}

variable "additional_execution_role" {
  description = "(Optional) Additional Execution Policy Role"
  type        = list(any)
  default     = []
}

variable "additional_deployer_role" {
  description = "(Optional) Additional Deployer Policy Role"
  type        = list(any)
  default     = []
}
