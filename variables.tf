variable "alias_name" {
  description = "Name for the alias (defaults to module ID)"
  type        = string
  default     = null
}

variable "function_name" {
  description = "Name or ARN of the Lambda function"
  type        = string
  validation {
    condition     = length(var.function_name) > 0
    error_message = "function_name must not be empty."
  }
}

variable "function_version" {
  description = "Lambda function version to point the alias at"
  type        = string
  default     = "$LATEST"
}

variable "description" {
  description = "Description of the alias"
  type        = string
  default     = null
}

variable "additional_version_weights" {
  description = "Map of version to weight for traffic shifting"
  type        = map(number)
  default     = null
}
