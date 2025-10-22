variable "security_group_id" {
  type        = string
  description = "The ID of the security group to apply rules to"
}

variable "ingress_rule_list" {
  type = list(object({
    from_port                = number
    to_port                  = number
    protocol                 = string
    description              = optional(string)
    cidr_blocks              = optional(list(string))
    ipv6_cidr_blocks         = optional(list(string))
    source_security_group_id = optional(string)
  }))
  default = []
}

variable "egress_rule_list" {
  type = list(object({
    from_port                = number
    to_port                  = number
    protocol                 = string
    description              = optional(string)
    cidr_blocks              = optional(list(string))
    ipv6_cidr_blocks         = optional(list(string))
    source_security_group_id = optional(string)
  }))
  default = []
}
