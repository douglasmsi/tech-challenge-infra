resource "aws_apigatewayv2_api" "tech-challenge-main" {
  name          = "main"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "tech-challenge-dev" {
  api_id = aws_apigatewayv2_api.tech-challenge-main.id

  name        = "dev"
  auto_deploy = true
}

resource "aws_security_group" "tech-challenge-vpc-link" {
  name   = "vpc-link"
  vpc_id = module.vpc.vpc_id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

resource "aws_apigatewayv2_vpc_link" "tech-challenge-eks" {
  name               = "eks"
  security_group_ids = [aws_security_group.tech-challenge-vpc-link.id]
  subnet_ids = module.vpc.private_subnets
}

/**
resource "aws_apigatewayv2_integration" "eks" {
  api_id = aws_apigatewayv2_api.tech-challenge-main.id

  integration_uri    = "arn:aws:elasticloadbalancing:us-east-1:<acc-id>:listener/net/a852b4f6ff0be41dfa1505018b083488/e8cf16c1a71e2a37/59bf9fd068f3f993"
  integration_type   = "HTTP_PROXY"
  integration_method = "ANY"
  connection_type    = "VPC_LINK"
  connection_id      = aws_apigatewayv2_vpc_link.tech-challenge-eks.id
}

resource "aws_apigatewayv2_route" "get_echo" {
  api_id = aws_apigatewayv2_api.tech-challenge-main.id

  route_key = "GET /clientes"
  target    = "integrations/${aws_apigatewayv2_integration.eks.id}"
}

output "hello_base_url" {
  value = "${aws_apigatewayv2_stage.tech-challenge-dev.invoke_url}/clientes"
}
**/