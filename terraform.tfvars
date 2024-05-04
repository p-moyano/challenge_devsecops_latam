tags = {
  "env"         = "DEV"
  "owner"       = "Pablo Moyano"
  "cloud"       = "AWS"
  "IAC"         = "Terraform"
  "IAC_Version" = "1.8.2"
}

apigw = "my-challenge-api"

integrationTypeApi = "AWS_PROXY"

integrationMethodApi = "POST"

integrationHttpMethod = ["POST", "GET"]

endpointhttpname = "my-challenge-http-api"

urlendpoint = "https://my-challenge-endpoint"

stagename = ["dev", "prod"]