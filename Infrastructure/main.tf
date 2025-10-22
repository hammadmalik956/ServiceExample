module "vpc" {
  source                 = "./modules/vpc"
  name                   = "${var.env}-${var.vpc.name}"
  cidr                   = var.vpc.cidr
  azs                    = var.vpc.azs
  private_subnets        = var.vpc.private_subnets
  public_subnets         = var.vpc.public_subnets
  enable_nat_gateway     = var.vpc.enable_nat_gateway
  single_nat_gateway     = var.vpc.single_nat_gateway
  one_nat_gateway_per_az = var.vpc.one_nat_gateway_per_az
  tags                   = merge(local.tags, var.vpc.tags)
}

module "k8s_sg_shells" {

  source = "./modules/security_groups"

  for_each = var.security_groups

  name              = each.value.name
  description       = each.value.description
  vpc_id            = module.vpc.vpc_id
  ingress_rule_list = []
  egress_rule_list  = []

  tags = try(each.value.tags, {})
}

module "k8s_sg_rules" {

  source = "./modules/security-group-rules"

  for_each = var.security_groups

  security_group_id = local.k8s_sg_ids[each.key]
  ingress_rule_list = local.k8s_resolved_rules[each.key].ingress_rule_list
  egress_rule_list  = local.k8s_resolved_rules[each.key].egress_rule_list
}

module "k8s_workload_nodes" {
  source = "./modules/ec2"

  for_each                    = var.ec2
  name                        = each.value.name
  ami                         = data.aws_ami.ubuntu_latest.id
  instance_type               = each.value.instance_type
  availability_zone           = element(module.vpc.azs, 0)
  key_name                    = each.value.key_name
  associate_public_ip_address = each.value.associate_public_ip_address
  subnet_id                   = element(module.vpc.public_subnets, 0)
  vpc_security_group_ids      = [module.k8s_sg_shells["${each.key}_sg"].id]
  create_security_group       = each.value.create_security_group


  create_iam_instance_profile = each.value.create_iam_instance_profile
  iam_role_description        = each.value.iam_role_description
  iam_role_policies           = each.value.iam_role_policies

  user_data_base64            = base64encode(local.user_data)
  user_data_replace_on_change = each.value.user_data_replace_on_change

  enable_volume_tags = each.value.enable_volume_tags
  root_block_device  = each.value.root_block_device



  tags = merge(local.tags, each.value.tags)
}

