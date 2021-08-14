# Code Deploy SlackNotification

## 概要

- CodeDeployのメッセージをAWS SNS経由で受け取り、Slackに通知する。

## IAM roles

### `CodeDeploySlackNotification`

以下を紐付け
- `LogWriteAccessForLambdaFunction`
  - [lambda_code_writer](../aws_iam/lambda_code_writer.md)
