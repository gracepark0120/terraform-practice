# resource "aws_lambda_function" "my_lambda" {
#   function_name = "my_lambda_function"
#   runtime       = "python3.8"
#   role          = aws_iam_role.lambda_exec_role.arn
#   handler       = "lambda_function.lambda_handler"

#   filename      = "${path.module}/lambda_function.zip"

#   source_code_hash = filebase64sha256("lambda_function.zip")
# }

# resource "aws_iam_role" "lambda_exec_role" {
#   name = "lambda_exec_role"

#   assume_role_policy = jsonencode({
#     "Version" : "2012-10-17",
#     "Statement": [
#       {
#         "Action": "sts:AssumeRole",
#         "Principal": {
#           "Service": "lambda.amazonaws.com"
#         },
#         "Effect": "Allow"
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "lambda_exec_policy" {
#   role       = aws_iam_role.lambda_exec_role.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
# }
