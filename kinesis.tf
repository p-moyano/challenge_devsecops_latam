# Recurso para la ingesta de datos de Kinesis a ser consumido por lambda, luego lambda salvará en dynamodb
resource "aws_kinesis_stream" "data_stream_ingest" {
  name        = "challenge-data-stream"
  shard_count = 1
}