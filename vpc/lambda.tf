data "archive_file" "lambda_retrieve" {
  type = "zip"
  source_dir = "${var.lambda_retrieve_code_dir}"
  output_path = "lambda_retrieve.zip"
}

resource "aws_lambda_function" "bru_retrieve_lambda_function" {
  filename = "${data.archive_file.lambda_retrieve.output_path}"
  function_name = "lambda-${ var.stream_code }${ var.sub_project }${ var.int_ext }${ var.environment }-${ var.service }-retrieve"
  role = "${aws_iam_role.lambda_role.arn}"
  handler = "index.handler"
  runtime = "nodejs4.3"
  source_code_hash = "${base64sha256(file("${data.archive_file.lambda_retrieve.output_path}"))}"
  publish = true
}

resource "aws_lambda_permission" "allow_aws_api_gateway_retrieve" {
  statement_id   = "AllowExecutionFromApiGateway"
  action         = "lambda:InvokeFunction"
  function_name  = "${aws_lambda_function.bru_retrieve_lambda_function.arn}"
  principal      = "apigateway.amazonaws.com"
}

resource "aws_iam_role" "lambda_role" {
  name = "iamrole-lambda-${ var.stream_code }${ var.sub_project }${ var.int_ext }${ var.environment }-${ var.service }"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "iam_policy_lambda_role" {
  role = "${aws_iam_role.lambda_role.id}"
  name = "iampolicy-lambda_role-${ var.stream_code }${ var.sub_project }${ var.int_ext }${ var.environment }-${ var.service }"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "logs:*"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
EOF
}

output "aws_iam_role.lambda_role.id" {
  value = "${aws_iam_role.lambda_role.id}"
}

output "aws_iam_role.lambda_role.arn" {
  value = "${aws_iam_role.lambda_role.arn}"
}

output "aws_iam_role.lambda_role.create_date" {
  value = "${aws_iam_role.lambda_role.create_date}"
}

output "aws_iam_role.lambda_role.unique_id" {
  value = "${aws_iam_role.lambda_role.unique_id}"
}

output "aws_iam_role_policy.iam_policy_lambda_role.id" {
  value = "${aws_iam_role_policy.iam_policy_lambda_role.id}"
}

output "aws_lambda_function.bru_retrieve_lambda_function.id" {
  value = "${aws_lambda_function.bru_retrieve_lambda_function.id}"
}

output "aws_lambda_function.bru_retrieve_lambda_function.arn" {
  value = "${aws_lambda_function.bru_retrieve_lambda_function.arn}"
}

output "aws_lambda_function.bru_retrieve_lambda_function.invoke_arn" {
  value = "${aws_lambda_function.bru_retrieve_lambda_function.invoke_arn}"
}

output "aws_lambda_function.bru_retrieve_lambda_function.last_modified" {
  value = "${aws_lambda_function.bru_retrieve_lambda_function.last_modified}"
}

output "aws_lambda_function.bru_retrieve_lambda_function.qualified_arn" {
  value = "${aws_lambda_function.bru_retrieve_lambda_function.qualified_arn}"
}

output "aws_lambda_function.bru_retrieve_lambda_function.version" {
  value = "${aws_lambda_function.bru_retrieve_lambda_function.version}"
}

output "aws_lambda_permission.allow_aws_api_gateway_retrieve.id" {
  value = "${aws_lambda_permission.allow_aws_api_gateway_retrieve.id}"
}
