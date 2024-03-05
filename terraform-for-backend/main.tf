resource "aws_lambda_function" "myfunc" {
  filename          = data.archive_file.zip.output_path
  source_code_hash  = data.archive_file.zip.output_base64sha256
  function_name     = "myfunc"
  role              = aws_iam_role.iam_for_lambda.arn
  handler           = "func.lambda_handler" # func is the file and lambda_handler is the function in that file
  runtime           = "python3.8"
}


resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "lambda.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  })
}


resource "aws_iam_policy" "iam_policy_for_resume_project" {
  name        = "aws_iam_policy_for_terraform_resume_project_policy"
  path        = "/"
  description = "AWS IAM Policy for managing the resume project role"
  policy      =  jsonencode(
    {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "logs:CreateLogGroup",
            "Resource": "arn:aws:logs:us-east-1:381491947644:*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": [
                "arn:aws:logs:us-east-1:381491947644:log-group:/aws/lambda/cloud-resume-api:*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
              "dynamodb:GetItem",
              "dynamodb:UpdateItem",
              "dynamodb:PutItem"
            ],
            "Resource": "arn:aws:dynamodb:us-east-1:381491947644:table/cloud-resume-db"
        }
    ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  role = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.iam_policy_for_resume_project.arn
  }


data "archive_file" "zip"{
  type        = "zip"
  source_dir  = "${path.module}/lambda"
  output_path = "${path.module}/packedlambda.zip"
}

resource "aws_lambda_function_url" "url1" {
  function_name      = aws_lambda_function.myfunc.function_name
  authorization_type = "NONE"

  cors {
    allow_credentials = true
    allow_origins   = ["https://d28ybb4q6dt8nu.cloudfront.net"]
    #allow_origins = ["mahad-cloud-resume-challenge.s3.us-east-1.amazonaws.com"]
    allow_methods   = ["*"]
    allow_headers   = ["date", "keep-alive"]
    expose_headers  = ["keep-alive", "date"]
    max_age         = 86400
  }

}
