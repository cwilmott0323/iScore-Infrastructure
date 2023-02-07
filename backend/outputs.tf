output "api-gateway-execution-arn" {
  value = aws_api_gateway_rest_api.iScore-gateway.execution_arn
}

output "lambda-arn" {
  value = aws_lambda_function.iScore-API-lambda.arn
}