# Cloud Front Invalidation

## 概要

- CloudFrontのInvalidationを作成する。
- CodeDeployのアプリケーション名から作成先を決定する。

## IAM roles

### `CloudFrontInvalidation`

以下を紐付け
- `LogWriteAccessForLambdaFunction`
  - [lambda_code_writer](../aws_iam/lambda_code_writer.md)
- `CloudFrontInvalidationWriter`

## IAM policies

### `CloudFrontInvalidationWriter`

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "cloudfront:CreateInvalidation",
            "Resource": [
                "arn:aws:cloudfront::{account-id}:distribution/{distribution-id}"
            ]
        }
    ]
}
```
