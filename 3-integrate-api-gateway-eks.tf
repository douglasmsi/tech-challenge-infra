/*resource "aws_api_gateway_vpc_link" "tech-challenge-gateway-vpc-link" {
  name = "tech-challenge-gateway-vpc-link"
  target_arns = [var.load_balancer_arn]
}*/

resource "aws_api_gateway_rest_api" "tech-challenge-gateway" {
  name = "tech-challenge-gateway"
  description = "Gateway used for EKS. Managed by Terraform."
  endpoint_configuration {
  types = ["REGIONAL"]
  }
}

/** retirar depois de ter os valores de arn e endereço do load balancer
resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.tech-challenge-gateway.id
  parent_id   = aws_api_gateway_rest_api.tech-challenge-gateway.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy" {
  rest_api_id   = aws_api_gateway_rest_api.tech-challenge-gateway.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = "ANY"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.proxy"           = true
    "method.request.header.Authorization" = true
  }
}

resource "aws_api_gateway_integration" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.tech-challenge-gateway.id
  resource_id = aws_api_gateway_resource.proxy.id
  http_method = "ANY"

  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "http://${var.load_balancer_dns}/{proxy}"
  passthrough_behavior    = "WHEN_NO_MATCH"
  content_handling        = "CONVERT_TO_TEXT"

  request_parameters = {
    "integration.request.path.proxy"           = "method.request.path.proxy"
    "integration.request.header.Accept"        = "'application/json'"
    "integration.request.header.Authorization" = "method.request.header.Authorization"
  }

  connection_type = "VPC_LINK"
  connection_id   = aws_api_gateway_vpc_link.tech-challenge-gateway-vpc-link.id
}
*/


##### verificar

/*
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


resource "aws_apigatewayv2_integration" "eks" {
  api_id = aws_apigatewayv2_api.tech-challenge-main.id

  integration_uri    = "arn:aws:elasticloadbalancing:us-east-1:<acc-id>:listener/net/a852b4f6ff0be41dfa1505018b083488/e8cf16c1a71e2a37/59bf9fd068f3f993"
  integration_type   = "HTTP_PROXY"
  integration_method = "ANY"
  connection_type    = "VPC_LINK"
  connection_id      = aws_apigatewayv2_vpc_link.tech-challenge-eks.id
}

resource "aws_apigatewayv2_route" "get_clientes" {
  api_id = aws_apigatewayv2_api.tech-challenge-main.id

  route_key = "GET /clientes"
  target    = "integrations/${aws_apigatewayv2_integration.eks.id}"
}

output "clientes_base_url" {
  value = "${aws_apigatewayv2_stage.tech-challenge-dev.invoke_url}/clientes"
}
**/