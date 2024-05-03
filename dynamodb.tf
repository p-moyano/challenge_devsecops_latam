# Recurso para almacenar los datos en una tabla de DynamoDB
resource "aws_dynamodb_table" "challenge_data_table" {
  name         = "my-challenge-data-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"
  attribute {
    name = "id"
    type = "S"
  }
}
