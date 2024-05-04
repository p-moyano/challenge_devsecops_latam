import json
import boto3

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('my-challenge-data-table')  

def lambda_handler(event, context):
    for record in event['Records']:
        # Procesar el registro del stream de Kinesis
        data = json.loads(record['kinesis']['data'])
        
        # Insertar el registro en la tabla DynamoDB
        table.put_item(Item=data)
    
    return {
        'statusCode': 200,
        'body': json.dumps('Registros procesados exitosamente')
    }
