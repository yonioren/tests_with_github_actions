resource "aws_security_group" "this" {
  name = var.name
  description = var.description
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "ingress_by_cidr" {
  count = length(var.ingress_rules_by_cidr)
  type = "ingress"
  from_port = var.ingress_rules_by_cidr[count.index].from_port
  to_port = var.ingress_rules_by_cidr[count.index].to_port
  protocol = var.ingress_rules_by_cidr[count.index].protocol
  cidr_blocks = var.ingress_rules_by_cidr[count.index].cidr_blocks
  security_group_id = aws_security_group.this.id
}

resource "aws_security_group_rule" "ingress_by_sg" {
  count = length(var.ingress_rules_by_sg)
  type = "ingress"
  from_port = var.ingress_rules_by_sg[count.index].from_port
  to_port = var.ingress_rules_by_sg[count.index].to_port
  protocol = var.ingress_rules_by_sg[count.index].protocol
  source_security_group_id = var.ingress_rules_by_sg[count.index].source_security_group_id
  security_group_id = aws_security_group.this.id
}

resource "aws_security_group_rule" "ingress_by_self" {
  count = length(var.ingress_rules_by_self)
  type = "ingress"
  from_port = var.ingress_rules_by_self[count.index].from_port
  to_port = var.ingress_rules_by_self[count.index].to_port
  protocol = var.ingress_rules_by_self[count.index].protocol
  self = true
  security_group_id = aws_security_group.this.id
}

resource "aws_security_group_rule" "egress" {
  count = length(var.egress_rules)
  type = "egress"
  from_port = var.egress_rules[count.index].from_port
  to_port = var.egress_rules[count.index].to_port
  protocol = var.egress_rules[count.index].protocol
  cidr_blocks = var.egress_rules[count.index].cidr_blocks
  security_group_id = aws_security_group.this.id
}