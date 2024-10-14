output "name_servers" {
  value = aws_route53_zone.primary.name_servers
}

# output "lambda_arn" {
#   value = module.multi_resource_module.lambda_function_arn
# }



