resource "aws_amplify_app" "iscore-amplify" {
  name       = "iScore"
  repository = "https://github.com/cwilmott0323/iScore-Frontend"

  # The default build_spec added by the Amplify Console for React.
  build_spec = <<-EOT
    version: 0.1
    frontend:
      phases:
        preBuild:
          commands:
            - yarn install
        build:
          commands:
            - yarn run build
      artifacts:
        baseDirectory: build
        files:
          - '**/*'
      cache:
        paths:
          - node_modules/**/*
  EOT

  custom_rule {
    source = "</^[^.]+$|\\.(?!(css|gif|ico|jpg|js|png|txt|svg|woff|ttf)$)([^.]+$)/>"
    status = "200"
    target = "/index.html"
    condition = null
  }

  access_token = "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"

  environment_variables = {
    ENV = "test"
  }
}


resource "aws_amplify_branch" "main" {
  app_id      = aws_amplify_app.iscore-amplify.id
  branch_name = "main"

  framework = "React"
  stage     = "PRODUCTION"
}