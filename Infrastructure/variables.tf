variable "vpc" {
  description = "Virtual Private Cloud configuration"
}

variable "semantic_version" {
  description = "Meaningful version scheme"
  default     = "1.0.0"
}
variable "env" {
  description = "Deployment environment"
  type        = string

}

variable "ec2" {
  description = "EC2 instances configuration"
  type        = map(any)
  default     = {}

}

variable "security_groups" {
}