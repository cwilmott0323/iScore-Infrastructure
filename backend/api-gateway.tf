resource "aws_api_gateway_rest_api" "iScore-gateway" {
  body = jsonencode({
    "swagger" : "2.0",
    "info" : {
      "version" : "2023-02-04T03:14:51Z",
      "title" : "iScore-Gateway"
    },
    //"host" : "sj9klp6ugk.execute-api.us-east-2.amazonaws.com",
    "basePath" : "/dev",
    "schemes" : ["https"],
    "paths" : {
      "/accounts-create" : {
        "x-amazon-apigateway-any-method" : {
          "produces" : ["application/json"],
          "responses" : {
            "200" : {
              "description" : "200 response",
              "schema" : {
                "$ref" : "#/definitions/Empty"
              }
            }
          },
          "x-amazon-apigateway-integration" : {
            "httpMethod" : "POST",
            "uri" : "arn:aws:apigateway:us-east-2:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-2:025810692662:function:iScore-API/invocations",
            "responses" : {
              "default" : {
                "statusCode" : "200"
              }
            },
            "passthroughBehavior" : "when_no_match",
            "contentHandling" : "CONVERT_TO_TEXT",
            "type" : "aws_proxy"
          }
        }
      },
      "/accounts-login" : {
        "x-amazon-apigateway-any-method" : {
          "produces" : ["application/json"],
          "responses" : {
            "200" : {
              "description" : "200 response",
              "schema" : {
                "$ref" : "#/definitions/Empty"
              }
            }
          },
          "x-amazon-apigateway-integration" : {
            "httpMethod" : "POST",
            "uri" : "arn:aws:apigateway:us-east-2:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-2:025810692662:function:iScore-API/invocations",
            "responses" : {
              "default" : {
                "statusCode" : "200"
              }
            },
            "passthroughBehavior" : "when_no_match",
            "contentHandling" : "CONVERT_TO_TEXT",
            "type" : "aws_proxy"
          }
        }
      },
      "/accounts/me" : {
        "options" : {
          "consumes" : ["application/json"],
          "produces" : ["application/json"],
          "responses" : {
            "200" : {
              "description" : "200 response",
              "schema" : {
                "$ref" : "#/definitions/Empty"
              },
              "headers" : {
                "Access-Control-Allow-Origin" : {
                  "type" : "string"
                },
                "Access-Control-Allow-Methods" : {
                  "type" : "string"
                },
                "Access-Control-Allow-Headers" : {
                  "type" : "string"
                }
              }
            }
          },
          "x-amazon-apigateway-integration" : {
            "responses" : {
              "default" : {
                "statusCode" : "200",
                "responseParameters" : {
                  "method.response.header.Access-Control-Allow-Methods" : "'DELETE,GET,HEAD,OPTIONS,PATCH,POST,PUT'",
                  "method.response.header.Access-Control-Allow-Headers" : "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
                  "method.response.header.Access-Control-Allow-Origin" : "'*'"
                }
              }
            },
            "requestTemplates" : {
              "application/json" : "{\"statusCode\": 200}"
            },
            "passthroughBehavior" : "when_no_match",
            "type" : "mock"
          }
        },
        "x-amazon-apigateway-any-method" : {
          "produces" : ["application/json"],
          "responses" : {
            "200" : {
              "description" : "200 response",
              "schema" : {
                "$ref" : "#/definitions/Empty"
              }
            }
          },
          "x-amazon-apigateway-integration" : {
            "httpMethod" : "POST",
            "uri" : "arn:aws:apigateway:us-east-2:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-2:025810692662:function:iScore-API/invocations",
            "responses" : {
              "default" : {
                "statusCode" : "200"
              }
            },
            "passthroughBehavior" : "when_no_match",
            "contentHandling" : "CONVERT_TO_TEXT",
            "type" : "aws_proxy"
          }
        }
      },
      "/verify" : {
        "x-amazon-apigateway-any-method" : {
          "produces" : ["application/json"],
          "responses" : {
            "200" : {
              "description" : "200 response",
              "schema" : {
                "$ref" : "#/definitions/Empty"
              }
            }
          },
          "x-amazon-apigateway-integration" : {
            "httpMethod" : "POST",
            "uri" : "arn:aws:apigateway:us-east-2:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-2:025810692662:function:iScore-API/invocations",
            "responses" : {
              "default" : {
                "statusCode" : "200"
              }
            },
            "passthroughBehavior" : "when_no_match",
            "contentHandling" : "CONVERT_TO_TEXT",
            "type" : "aws_proxy"
          }
        }
      }
    },
    "definitions" : {
      "Empty" : {
        "type" : "object",
        "title" : "Empty Schema"
      }
    },
    "x-amazon-apigateway-gateway-responses" : {
      "DEFAULT_4XX" : {
        "responseParameters" : {
          "gatewayresponse.header.Access-Control-Allow-Methods" : "'DELETE,GET,HEAD,OPTIONS,PATCH,POST,PUT'",
          "gatewayresponse.header.Access-Control-Allow-Origin" : "'*'",
          "gatewayresponse.header.Access-Control-Allow-Headers" : "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
        }
      }
    }
  })

  name = "iScore-Gateway"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_deployment" "iScore-deploy" {
  rest_api_id = aws_api_gateway_rest_api.iScore-gateway.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.iScore-gateway.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "dev" {
  deployment_id = aws_api_gateway_deployment.iScore-deploy.id
  rest_api_id   = aws_api_gateway_rest_api.iScore-gateway.id
  stage_name    = "dev"
}

#resource "aws_api_gateway_method_settings" "methods" {
#  rest_api_id = aws_api_gateway_rest_api.iScore-gateway.id
#  stage_name  = aws_api_gateway_stage.dev.stage_name
#  method_path = "*/*"
#
#  settings {}
#}

resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "AllowMyDemoAPIInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.iScore-API-lambda.function_name
  principal     = "apigateway.amazonaws.com"

  # The /*/*/* part allows invocation from any stage, method and resource path
  # within API Gateway REST API.
  source_arn = "${aws_api_gateway_rest_api.iScore-gateway.execution_arn}/*/*/*"
}