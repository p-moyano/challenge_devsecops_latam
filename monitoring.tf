#Recurso para las alarmas en CloudWatch
resource "aws_cloudwatch_metric_alarm" "dynamodb_alarm" {
  alarm_name          = "dynamodb-throttling-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "ConsumedWriteCapacityUnits"
  namespace           = "AWS/DynamoDB"
  period              = 120
  statistic           = "Sum"
  threshold           = 10
  alarm_description   = "Alarma cuando la capacidad de la escritura en DynamoDB está siendo afectada"
}
