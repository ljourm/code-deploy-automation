# Code Deploy SlackNotification

## 概要

- CodeDeployのメッセージをAWS SNS経由で受け取り、Slackに通知する。

## IAM roles

### `CodeDeploySlackNotification`

以下を紐付け
- `LogWriteAccessForLambdaFunction`
  - [lambda_code_writer](./iam_log_writer.md)

## Environment

Lambdaの画面から環境変数を設定する。

- `SLACK_WEBHOOK_URI`
  - Slackのwebhookのuri
  - e.g. `https://hooks.slack.com/services/xxx/xxx/xxx`
