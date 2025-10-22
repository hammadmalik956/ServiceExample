resource "aws_security_group" "default" {
  description = var.description
  vpc_id      = var.vpc_id
  name        = var.name
  tags =  var.tags
}
 
resource "aws_security_group_rule" "default_ingress_rules" {
  count = length(var.ingress_rule_list)

  source_security_group_id = var.ingress_rule_list[count.index].source_security_group_id
  security_group_id        = aws_security_group.default.id
  cidr_blocks              = var.ingress_rule_list[count.index].cidr_blocks
  description              = var.ingress_rule_list[count.index].description
  from_port                = var.ingress_rule_list[count.index].from_port
  protocol                 = var.ingress_rule_list[count.index].protocol
  to_port                  = var.ingress_rule_list[count.index].to_port
  type                     = "ingress"

}
   
# tfsec:ignore:aws-vpc-no-public-egress-sgr 
resource "aws_security_group_rule" "default_egress_rules" {
  count = length(var.egress_rule_list)

  source_security_group_id = null
  security_group_id        = aws_security_group.default.id
  cidr_blocks              = var.egress_rule_list[count.index].cidr_blocks
  description              = var.egress_rule_list[count.index].description
  from_port                = var.egress_rule_list[count.index].from_port
  protocol                 = var.egress_rule_list[count.index].protocol
  to_port                  = var.egress_rule_list[count.index].to_port
  type                     = "egress"
}
