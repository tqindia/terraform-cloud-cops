resource "aws_route53_zone" "public" {
  name = var.domain
  tags = {
    Name               = "cops-${var.env_name}"
    "cops-environment" = var.env_name
  }
  force_destroy = true
}