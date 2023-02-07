output "amplify-domain" {
  value = aws_amplify_app.iscore-amplify.default_domain
}

output "amplify-branch" {
  value = aws_amplify_app.iscore-amplify.production_branch
}