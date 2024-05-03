#Recurso para crear el bucket s3 que va a servir para la función lambda
resource "aws_s3_bucket" "bucket_lambda" {
  bucket = "bucket-lambda"  
  tags = {
    Name = "Bucket lambda"
    description = "Bucket para subir desplegar la función lambda"
  }
}

#Recurso para subir el objeto que contiene el código
resource "aws_s3_bucket_object" "lambda_object" {
  bucket = aws_s3_bucket.bucket_lambda.id
  key    = "lambdaapigw.py"  
  source = "scripts/lambdaapigw.py" 
  depends_on = [aws_s3_bucket.bucket_lambda]  # Me aseguro de que esté creado el bucket
}