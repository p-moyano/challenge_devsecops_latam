# Recurso para la ingesta de datos de Kinesis a ser consumido por lambda, luego lambda salvará en dynamodb
resource "aws_kinesis_stream" "data_stream_ingest" {
  name        = "challenge-data-stream"
  shard_count = 1
}



resource "aws_lambda_event_source_mapping" "kinesis_trigger" {
  event_source_arn  = aws_kinesis_stream.data_stream_ingest.arn
  function_name     = aws_lambda_function.lambda_ingest
  starting_position = "LATEST"
  batch_size        = 100
}
