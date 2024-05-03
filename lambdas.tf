# Recurso lambda para obtener los datos de dynamodb
resource "aws_lambda_function" "lambda_get_data" {
  filename      = aws_s3_bucket_object.lambda_object.key
  function_name = "getdatafromdynamodb"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.8"
}

#Role IAM para darle permisos a la función Lambda
resource "aws_iam_role" "lambda_role" {
  name               = "lambda_execution_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}