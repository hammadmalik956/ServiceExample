semantic_version = "1.0.0"
env              = "prod"
vpc = {
  name                   = "mirsys"
  azs                    = ["us-east-2a", "us-east-2b"]
  cidr                   = "10.0.0.0/16"
  private_subnets        = ["10.0.0.0/24", "10.0.1.0/24"]
  public_subnets         = ["10.0.3.0/24", "10.0.4.0/24"]
  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  tags = {}
}

ec2 = {
  masters = {
    master = {
      name                        = "k8s-master"
      key_name                    = "mirsys-key"
      create_security_group       = false
      associate_public_ip_address = true
      instance_type               = "t3.medium"
      iam_role_use_name_prefix    = false
      create_iam_instance_profile = true
      iam_role_description        = "IAM role for EC2 instance"
      iam_role_policies = {
        SSMParameterStoreAccess = "arn:aws:iam::055545057328:policy/SSMParameterPolici"
      }
      user_data_replace_on_change = true
      enable_volume_tags          = false
      root_block_device = {
        encrypted  = true
        type       = "gp3"
        throughput = 200
        size       = 50
        tags = {
          Name = "master-root-block"
        }
      }
      tags = {

      }
    }
  }
  slaves = {
    slave1 = {
      name                        = "k8s-slave1"
      instance_type               = "t3.medium"
      key_name                    = "mirsys-key"
      associate_public_ip_address = true
      create_security_group       = false
      create_iam_instance_profile = true
      iam_role_use_name_prefix    = false
      iam_role_description        = "IAM role for EC2 instance"
      iam_role_policies = {
        SSMParameterStoreAccess = "arn:aws:iam::055545057328:policy/SSMParameterPolici"
      }
      user_data_replace_on_change = true
      enable_volume_tags          = false
      root_block_device = {
        encrypted  = true
        type       = "gp3"
        throughput = 200
        size       = 50
        tags = {
          Name = "slave1-root-block"
        }
      }
      tags = {

      }
    }
    slave2 = {
      name                        = "k8s-slave2"
      associate_public_ip_address = true
      key_name                    = "mirsys-key"
      instance_type               = "t3.medium"
      create_security_group       = false
      create_iam_instance_profile = true
      iam_role_description        = "IAM role for EC2 instance"
      iam_role_use_name_prefix    = false
      iam_role_policies = {
        SSMParameterStoreAccess = "arn:aws:iam::055545057328:policy/SSMParameterPolici"
      }
      user_data_replace_on_change = true
      enable_volume_tags          = false
      root_block_device = {
        encrypted  = true
        type       = "gp3"
        throughput = 200
        size       = 50
        tags = {
          Name = "slave2-root-block"
        }
      }
      tags = {}

    }
  }
}

security_groups = {
  master_sg = {
    name        = "master-sg"
    description = "Public-facing ALB SG"
    ingress_rule_list = [
      {
        source_security_group_id = null
        cidr_blocks              = ["10.0.0.0/16"]
        description              = "app access from internet"
        from_port                = 10248
        protocol                 = "tcp"
        to_port                  = 10260
      },
      {
        source_security_group_id = null
        cidr_blocks              = ["0.0.0.0/0"]
        description              = "SSH access within vpc"
        from_port                = 22
        protocol                 = "tcp"
        to_port                  = 22
      },
      {
        source_security_group_id = null
        cidr_blocks              = ["10.0.0.0/16"]
        description              = "etcd access within vpc "
        from_port                = 2379
        protocol                 = "tcp"
        to_port                  = 2380
      },
      {
        source_security_group_id = null
        cidr_blocks              = ["10.0.0.0/16"]
        description              = "Kubernetes API server access within vpc"
        from_port                = 6443
        protocol                 = "tcp"
        to_port                  = 6443
      },
    ]
    egress_rule_list = [
      {
        source_security_group_id = null
        cidr_blocks              = ["0.0.0.0/0"]
        description              = "Allow all outbound"
        from_port                = 0
        protocol                 = "-1"
        to_port                  = 0
      }
    ]
  }

  slave1_sg = {
    name        = "slave1-sg"
    description = "Allow traffic from ALB"
    ingress_rule_list = [

      {
        source_security_group_id = null
        cidr_blocks              = ["10.0.0.0/16"]
        description              = "kube proxy access within vpc"
        from_port                = 10256
        protocol                 = "tcp"
        to_port                  = 10256
      },
      {
        source_security_group_id = null
        cidr_blocks              = ["10.0.0.0/16"]
        description              = "node ports access within vpc"
        from_port                = 30000
        protocol                 = "tcp"
        to_port                  = 32767
      },
      {
        source_security_group_id = null
        cidr_blocks              = ["10.0.0.0/16"]
        description              = "kubelet port access within vpc"
        from_port                = 10250
        protocol                 = "tcp"
        to_port                  = 10250
      },
      {
        source_security_group_id = null
        cidr_blocks              = ["0.0.0.0/0"]
        description              = "kubelet port access within vpc"
        from_port                = 22
        protocol                 = "tcp"
        to_port                  = 22
      },
    ]
    egress_rule_list = [
      {
        source_security_group_id = null
        cidr_blocks              = ["0.0.0.0/0"]
        description              = "Allow all outbound"
        from_port                = 0
        protocol                 = "-1"
        to_port                  = 0
      }
    ]
  }
  slave2_sg = {
    name        = "slave2-sg"
    description = "RDS Security Group to accept trrafic only from backend server"
    ingress_rule_list = [
      {
        source_security_group_id = null
        cidr_blocks              = ["10.0.0.0/16"]
        description              = "kube proxy access within vpc"
        from_port                = 10256
        protocol                 = "tcp"
        to_port                  = 10256
      },
      {
        source_security_group_id = null
        cidr_blocks              = ["10.0.0.0/16"]
        description              = "node ports access within vpc"
        from_port                = 30000
        protocol                 = "tcp"
        to_port                  = 32767
      },
      {
        source_security_group_id = null
        cidr_blocks              = ["10.0.0.0/16"]
        description              = "kubelet port access within vpc"
        from_port                = 10250
        protocol                 = "tcp"
        to_port                  = 10250
      },
      {
        source_security_group_id = null
        cidr_blocks              = ["0.0.0.0/0"]
        description              = "kubelet port access within vpc"
        from_port                = 22
        protocol                 = "tcp"
        to_port                  = 22
      },
    ]
    egress_rule_list = [
      {
        source_security_group_id = null
        cidr_blocks              = ["0.0.0.0/0"]
        description              = "Allow outbound traffic"
        from_port                = 0
        protocol                 = -1
        to_port                  = 0
      }
    ]
  }

}