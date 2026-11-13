variable "state_passphrase" {
  description = "Encrypts the state and plans stored in R2."
  type        = string
  sensitive   = true
}

variable "portainer_url" {
  type    = string
  default = "https://containers.subzerodev.com"
}

variable "portainer_api_key" {
  type      = string
  sensitive = true
}

variable "cf_access_client_id" {
  description = "Cloudflare Access service token in front of Portainer."
  type        = string
  sensitive   = true
}

variable "cf_access_client_secret" {
  type      = string
  sensitive = true
}

variable "env" {
  description = "Plain stack values read from the running stack (private var-file)."
  type        = map(string)
}

variable "secrets" {
  description = "Secret stack values read from the running stack (private var-file). They must stay exactly as they are: the database password lives in its volume and the keys sign what Gitea stored."
  type        = map(string)
  sensitive   = true

  validation {
    condition     = alltrue([for k in ["DB_PASSWORD", "SECRET_KEY", "INTERNAL_TOKEN", "LFS_JWT_SECRET", "RUNNER_TOKEN", "ADMIN_PASSWORD"] : contains(keys(var.secrets), k)])
    error_message = "secrets needs DB_PASSWORD, SECRET_KEY, INTERNAL_TOKEN, LFS_JWT_SECRET, RUNNER_TOKEN and ADMIN_PASSWORD."
  }
}
