variable "tags" {
  description = "tags para los recursos"
  type        = map(string)

}

variable "apigw" {
  description = "nombre del api gateway"
  type        = string
}

variable "integrationTypeApi" {
  description = "tipo de integración a usar"
  type        = string
}

variable "integrationMethodApi" {
  description = "metodo a utilizar por la api"
  type        = string
}

variable "integrationHttpMethod" {
  description = "metodo http a utilizar por la api"
  type        = list(string)
}

variable "endpointhttpname" {
  description = "nombre para el endpoint http"
  type        = string
}

variable "urlendpoint" {
  description = "url del endpoint"
  type        = string
}

variable "stagename" {
  description = "nombre para el ambiente"
  type        = list(string)
}