# Code Deploy Performer

## 概要

- CodeDeployを実行する。
- S3のファイル変更がトリガーとなって実行されることを想定している。
- 実行するCodeDeployのアプリケーション名は変更されたS3ファイル名から決定する。
- CodeDeployの実行後、Slackに開始の旨を通知する。

## IAM roles

### `CodeDeployPerformer`

以下を紐付け
- `LogWriteAccessForLambdaFunction`
  - [lambda_code_writer](./iam_log_writer.md)
- `CodeDeployCreation`

## IAM policies

### `CodeDeployCreation`

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "codedeploy:CreateDeployment",
                "codedeploy:CreateDeploymentConfig",
                "codedeploy:GetApplicationRevision",
                "codedeploy:GetDeploymentConfig",
                "codedeploy:RegisterApplicationRevision"
            ],
            "Resource": "*"
        }
    ]
}
```

## Environment

Lambdaの画面から環境変数を設定する。

- `SLACK_WEBHOOK_URI`
  - Slackのwebhookのuri
  - e.g. `https://hooks.slack.com/services/xxx/xxx/xxx`
