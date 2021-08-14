# Code Deploy Performer

## 概要

- CodeDeployを実行する。
- S3のファイル変更がトリガーとなって実行されることを想定している。
- 実行するCodeDeployのアプリケーション名は変更されたS3ファイル名から決定する。

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
