# S3 Timestamp Renamer

## 概要

- 現在の時刻がS3上のファイル名の接尾辞と一致した場合、ファイル名をリネームする。

## 実行例

実行前のファイル一覧
- `filename.zip`
- `filename.zip.2021080118`
- `filename_second.zip`
- `filename_second.zip.new`

2021-08-01 18:00~19:00 に実行した場合

- ファイル名 `filename.zip.2021080118` の接尾辞 `2021080118` が現在の時刻と一致するため、以下の順にリネームが実行される。
  - `filename_second.zip.new` -> `filename_second.zip`
  - `filename.zip.2021080118` -> `filename.zip`

実行後のファイル一覧
- `filename.zip`
- `filename_second.zip.new`

## IAM roles

### `S3TimestampRenamer`

以下を紐付け
- `LogWriteAccessForLambdaFunction`
  - [lambda_code_writer](./iam_log_writer.md)
- `S3RenameAccessForTimestampRenamer`

## IAM policies

### `S3RenameAccessForTimestampRenamer`
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:ListBucket",
                "s3:DeleteObject"
            ],
            "Resource": [
                "arn:aws:s3:::{bucket_name}/*.zip",
                "arn:aws:s3:::{bucket_name}"
            ]
        }
    ]
}
```
