resource "aws_security_group_rule" "ingress" {
  for_each = {
    for idx, rule in var.ingress_rule_list : "${idx}" => rule
  }

  type                     = "ingress"
  from_port               = each.value.from_port
  to_port                 = each.value.to_port
  protocol                = each.value.protocol
  description             = lookup(each.value, "description", null)
  security_group_id       = var.security_group_id

  cidr_blocks             = lookup(each.value, "cidr_blocks", null)
  ipv6_cidr_blocks        = lookup(each.value, "ipv6_cidr_blocks", null)
  source_security_group_id = lookup(each.value, "source_security_group_id", null)
}

resource "aws_security_group_rule" "egress" {
  for_each = {
    for idx, rule in var.egress_rule_list : "${idx}" => rule
  }

  type                     = "egress"
  from_port               = each.value.from_port
  to_port                 = each.value.to_port
  protocol                = each.value.protocol
  description             = lookup(each.value, "description", null)
  security_group_id       = var.security_group_id

  cidr_blocks             = lookup(each.value, "cidr_blocks", null)
  ipv6_cidr_blocks        = lookup(each.value, "ipv6_cidr_blocks", null)
  source_security_group_id = lookup(each.value, "source_security_group_id", null)
}
