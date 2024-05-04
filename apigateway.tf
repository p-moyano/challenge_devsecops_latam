# Recurso para la creación de  API Gateway
resource "aws_api_gateway_rest_api" "api_gateway" {
  name        = var.apigw
  description = "API para servir los datos almacenados en dynamodb"
}

# Recurso para el endpoint de DynamoDB en API Gateway
resource "aws_apigatewayv2_integration" "dynamodb_integration" {
  api_id                    = aws_api_gateway_rest_api.api_gateway.id
  integration_type          = var.integrationTypeApi
  integration_method        = var.integrationMethodApi
  integration_uri           = aws_dynamodb_table.challenge_data_table.arn
 # integration_connection_id = aws_api_gateway_rest_api.api_gateway.id
#  integration_http_method   = var.integrationHttpMethod[0]
}

# Recurso para el endpoint HTTP en API Gateway
resource "aws_api_gateway_rest_api" "http_api_gateway" {
  name        = var.endpointhttpname
  description = "API for serving HTTP endpoints"
}

# Recurso para el endpoint en API Gateway
resource "aws_api_gateway_resource" "http_api_resource" {
  parent_id   = aws_api_gateway_rest_api.http_api_gateway.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.http_api_gateway.id
  path_part   = "data"
}

# Recurso para el método GET en el punto final HTTP
resource "aws_api_gateway_method" "http_api_method" {
  rest_api_id = aws_api_gateway_rest_api.http_api_gateway.id
  resource_id = aws_api_gateway_resource.http_api_resource.id
  http_method = "GET"
  authorization = "NONE"
}

# Recurso para la integración HTTP en API Gateway
resource "aws_api_gateway_integration" "http_api_integration" {
  rest_api_id             = aws_api_gateway_rest_api.http_api_gateway.id
  resource_id             = aws_api_gateway_resource.http_api_resource.id
  http_method             = aws_api_gateway_method.http_api_method.http_method
  integration_http_method = var.integrationHttpMethod[1]
  type                    = "HTTP"
  uri                     = var.urlendpoint
}

# Recurso para la implementación de la API Gateway
resource "aws_api_gateway_deployment" "http_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.http_api_gateway.id
  stage_name  = var.stagename[0]
}

# Recurso para crear la politica para los permisos de cloudwatch
resource "aws_iam_policy" "api_gateway_to_cloudwatch" {
  name        = "api-gateway-to-cloudwatch"
  description = "Policy for api gateway to write cloudwatch logs"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:DescribeLogGroups",
                "logs:DescribeLogStreams",
                "logs:PutLogEvents",
                "logs:GetLogEvents",
                "logs:FilterLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

# Recurso para crear el role para cloudwatch
resource "aws_iam_role" "api_gateway_to_cloudwatch" {
  name               = "api-gateway-to-cloudwatch"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "Service": "apigateway.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

# Recurso para atachar el la plolicy al role de iam
resource "aws_iam_role_policy_attachment" "api_gateway_to_cloudwatch" {
  role       = aws_iam_role.api_gateway_to_cloudwatch.name
  policy_arn = aws_iam_policy.api_gateway_to_cloudwatch.arn
}