# Recurso para la creación de  API Gateway
resource "aws_api_gateway_rest_api" "api_gateway" {
  name        = "my-challenge-api"
  description = "API para servir los datos almacenados en dynamodb"
}

# Recurso para el endpoint de DynamoDB en API Gateway
resource "aws_api_gateway_v2_integration" "dynamodb_integration" {
  api_id                    = aws_api_gateway_rest_api.api_gateway.id
  integration_type          = "AWS_PROXY"
  integration_method        = "POST"
  integration_uri           = aws_dynamodb_table.challenge_data_table.arn
  integration_connection_id = aws_api_gateway_rest_api.api_gateway.id
  integration_http_method   = "POST"
}

# Recurso para el endpoint HTTP en API Gateway
resource "aws_api_gateway_rest_api" "http_api_gateway" {
  name        = "my-challenge-http-api"
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
}

# Recurso para la integración HTTP en API Gateway
resource "aws_api_gateway_integration" "http_api_integration" {
  rest_api_id             = aws_api_gateway_rest_api.http_api_gateway.id
  resource_id             = aws_api_gateway_resource.http_api_resource.id
  http_method             = aws_api_gateway_method.http_api_method.http_method
  integration_http_method = "GET"
  type                    = "HTTP"
  uri                     = "https://my-challenge-endpoint" # Cambia esto por tu servicio real
}

# Recurso para la implementación de la API Gateway
resource "aws_api_gateway_deployment" "http_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.http_api_gateway.id
  stage_name  = "dev"
}

# Terraform para definir el recurso de AWS Lambda
resource "aws_lambda_function" "api_lambda_function" {
  filename      = "api_lambda_function.zip"
  function_name = "apiLambdaFunction"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.8"
}
