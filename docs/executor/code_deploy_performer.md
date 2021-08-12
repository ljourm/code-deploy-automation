# Cloud Front Invalidation

## 概要

- CodeDeployを実行する。
- 実行するCodeDeployのアプリケーション名は変更されたS3ファイル名からけて地する。

## IAM roles

### `CodeDeployPerformer`

以下を紐付け
- `LogWriteAccessForLambdaFunction`
  - [lambda_code_writer](../aws_iam/lambda_code_writer.md)
- `CodeDeployCreation`
- `S3ReadAccessForCodeDeploy`

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

### `S3ReadAccessForCodeDeploy`
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:GetObjectVersion"
            ],
            "Resource": "arn:aws:s3:::{bucket_name}/*.zip"
        }
    ]
}
```
