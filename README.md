# Challenge_devsecops_latam
Repo created for the latam customer challenge


## Parte 1 del proyecto
### Consideraciones para la infrastructura:
1. Api HTTP: para leer los datos de la base y exponerlos, se pensó en un esquema con:
  - una base de datos dynamodb ideal para grandes ingestas y lecturas de alto rendimiento. 
  - una aplicación en lambda que se encargue de leer los datos y los exponga a una petición http.
  - un apigatway que proxee la petición desde internet al endpoint http.

2. Para la ingesta:
  - Kinesis data stream: suponiendo que tenemos distintos producers/sources, es ideal como servicio serverless para procesar la ingesta y enviarlo a un consumer.
  - Función lambda para consumir la ingesta y guardar los datos en la base dynamodb.
  - El esquema kinesis/lambda sirve como implementación para el concepto de pub/sub.
  - Base de dynamodb.

3. Deploy de la infrastructura mediante terraform como IaC
  - Todos los servicios se despliegan con terraform.
  - tfstate en bucket s3 con lock state en dynamodb.
  - Por cuestiones de tiempo, no se logró modularizar y crear reusables para aplicar el concepto de DRY (don't repeat yourself) 
  - Se adjunta logs del terraform plan e imagen del terraform init. Para la prueba se utilizó cuenta personal de AWS, por lo que no se aplicaron los cambios finalmente para no incurrir en costos.

## Parte 2 del proyecto
### Consideraciones para el circuito de CI / CD
1.  API HTTP: Como se indicó en la infrastructura pensada, se expone mediante un api gateway y una función lambda.
2.  Deploy API: Se generó un workflow en github actions que se encargará de descargar el artefacto y desplegarlo cuando se haga un push de código al main y generado el update en el código.
3. Para la ingesta: Kinesis data stream y función lambda.
4. Se adjunta diagrama de arquitectura.

## Parte 3 del proyecto
### Consideraciones y puntos críticos 
1. Teniendo en cuenta que preferimos el uso de GH Actions, existen módulos en el marketplace que se pueden incorporar al circuito, de postman/newman. De esta manera además de agregar la capa de test, se puede hacer de forma automatizada con reporte de resultados.
2. Otras formas de testearlo pueden ser: mediante python con pytest (encajaría bien teniendo en cuenta que la app es python) y otra herramienta muy conocida que también se adaptaría bien al esquema es selenium. Para el primer caso se puede incorporar el script a un workflow de action mientras que la otra se podría utilizar la interfaz gui para simular una prueba de usuario.
3. 4. Posibles puntos críticos del sistema: en un primer esquema se está utilizando una sola "shard" para Kinesis que procesa 1000 records x segundo. Suponiendo que la escala de ingesta es superior, se puede robustecer agregando más shard.
Otro punto crítico es la base de datos dynamodb. En un esquema de alto rendimiento, se ajustaría el valor de read/write en modo provisioned para que escale en función de dicho valor y optimizar los costos.

## Parte 4 del proyecto
### Consideraciones para el monitoreo
1. Métricas adicionales: 
  - Métrica de latencia: que mida solicitud entre el extremo origen y destino, es decir, el flujo completo. Con esto contemplariamos posibles cuellos de botella y baja en el rendimiento.
  - Tasa de errores: con esta métrica podríamos analizar cantidad de errores y posibles bugs o errores en el funcionamiento de la app.
  - Tasa de éxito: con esta métrica podríamos comparar las peticiones realizadas con éxito contra el total de peticiones. Una diferencia pequeña nos daría una visión de la calidad y fiabilidad del servicio.
2. 3. Herramienta de monitoreo
  - Como herramienta de terceros una buena alternativa es New Relic ya que posee tanto APM como logs y posibilidad de crear métricas y dashboards. New relic necesita alimentarse de una base de datos dynamodb y se podrían enviar los datos crudos con una función lambda.
