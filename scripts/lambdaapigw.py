# Función lambda para obtener los datos de dynamodb
import json
import boto3

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('my-challenge-data-table') 

def lambda_handler(event, context):
    response = table.scan()  # Realiza una operación de escaneo en la tabla DynamoDB
    items = response['Items']  # Obtiene los elementos escaneados
    return {
        'statusCode': 200,
        'body': json.dumps(items)  # Devuelve los elementos como respuesta
    }
