data "aws_iam_policy_document" "assume_role" {
  depends_on = [aws_iam_role_policy_attachment.lambda_policy]
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_lambda_function" "lambda" {
  depends_on = [data.aws_iam_policy_document.assume_role]
  function_name = "test1"
  s3_bucket     = "codz-bucket"
  s3_key        = "lambda/${var.lambda_name}.zip"
  handler       = "lambda.lambda_handler"
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_exec.arn
}

resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  depends_on = [aws_iam_role.lambda_exec]
  role       = aws_iam_role.lambda_exec.name
  policy_arn  = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "null_resource" "create_lambda_zip" {
  provisioner "local-exec" {
    command = <<EOT
      git clone -b main https://github.com/muddukrishnak/DataPipelines.git modules\lambda\scripts && cd modules\lambda\scripts\${var.lambda_name} && tar -a -c -f ..\..\scripts_zip\${var.lambda_name}.zip * && cd ..\..\..\.. && rmdir /s /q modules\lambda\scripts && awslocal s3 cp modules\lambda\scripts_zip\${var.lambda_name}.zip s3://codz-bucket/lambda/${var.lambda_name}.zip
    EOT
  }

  triggers = {
    timestamp = timestamp()
  }
}