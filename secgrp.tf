resource "aws_security_group" "vprofile-bean-elb-sg" {
  vpc_id      = module.vpc.vpc_id
  name        = "vprofile-bean-elb-sg"
  description = "vprofile-bean-elb-sg"
  tags = {
    Name    = "vprofile-bean-elb"
    Project = var.PROJECT
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_forELB" {
  security_group_id = aws_security_group.vprofile-bean-elb-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "allowAllOutbound_ipv4forELB" {
  security_group_id = aws_security_group.vprofile-bean-elb-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "allowAllOutbound_ipv6forELB" {
  security_group_id = aws_security_group.vprofile-bean-elb-sg.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_security_group" "bastion-host-sg" {
  vpc_id      = module.vpc.vpc_id
  name        = "bastion-host-sg"
  description = "bastion-host-sg"
  tags = {
    Name    = "bastion-host"
    Project = var.PROJECT
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_for_bastion_host" {
  security_group_id = aws_security_group.bastion-host-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allowAllOutbound_ipv4forBastion" {
  security_group_id = aws_security_group.bastion-host-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "allowAllOutbound_ipv6forBastion" {
  security_group_id = aws_security_group.bastion-host-sg.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_security_group" "vprofile-prodbean-sg" {
  vpc_id      = module.vpc.vpc_id
  name        = "vprofile-prodbean-sg"
  description = "vprofile-prodbean-sg"
  tags = {
    Name    = "vprofile-prodbean"
    Project = var.PROJECT
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_for_prodbean" {
  security_group_id = aws_security_group.vprofile-prodbean-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_from_elb_to_prodbean" {
  security_group_id            = aws_security_group.vprofile-prodbean-sg.id
  referenced_security_group_id = aws_security_group.vprofile-bean-elb-sg.id
  ip_protocol                  = "tcp"
  from_port                    = 80
  to_port                      = 80
}

resource "aws_vpc_security_group_egress_rule" "allowAllOutbound_ipv4forProdBean" {
  security_group_id = aws_security_group.vprofile-prodbean-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "allowAllOutbound_ipv6forProdBean" {
  security_group_id = aws_security_group.vprofile-prodbean-sg.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_security_group" "vprofile-backend-sg" {
  vpc_id      = module.vpc.vpc_id
  name        = "vprofile-backend-sg"
  description = "vprofile-backend-sg"
  tags = {
    Name    = "vprofile-backend"
    Project = var.PROJECT
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_all_from_bean_instance_to_backend" {
  security_group_id            = aws_security_group.vprofile-backend-sg.id
  referenced_security_group_id = aws_security_group.vprofile-prodbean-sg.id
  ip_protocol                  = "tcp"
  from_port                    = 0
  to_port                      = 65535
}

resource "aws_vpc_security_group_ingress_rule" "allow_3306_from_bastion_instance" {
  security_group_id            = aws_security_group.vprofile-backend-sg.id
  referenced_security_group_id = aws_security_group.bastion-host-sg.id
  ip_protocol                  = "tcp"
  from_port                    = 3306
  to_port                      = 3306
}

resource "aws_vpc_security_group_ingress_rule" "allow_backend_to_itself" {
  security_group_id            = aws_security_group.vprofile-backend-sg.id
  referenced_security_group_id = aws_security_group.vprofile-backend-sg.id
  ip_protocol                  = "tcp"
  from_port                    = 0
  to_port                      = 65535
}

resource "aws_vpc_security_group_egress_rule" "allowAllOutbound_ipv4forBackend" {
  security_group_id = aws_security_group.vprofile-backend-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "allowAllOutbound_ipv6forBackend" {
  security_group_id = aws_security_group.vprofile-backend-sg.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
