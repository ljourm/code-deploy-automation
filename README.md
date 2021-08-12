# Code deploy by lambda

## Forked

Forked from [Lambda template for ruby](https://github.com/ljourm/lambda-template-for-ruby)

## 概要

AWS Lambda + Ruby を使用する際のテンプレート。

- GitHub ActionsによるLambdaへのデプロイ
  - トリガーや送信先はGUIから設定する想定
- GitHub ActionsによるCI実行
- 各種テスト
  - rspec
  - rubocop
  - simplecov
- 環境変数 `APP_ENV` による環境の切り替え
  - production
  - staging
  - development
  - test
- Docker Composeによるローカル環境構築

## 環境

- AWS Lambda
- Ruby 2.7.4

## ドキュメント

- [開発方法](./docs/development.md)
- [デプロイ](./docs/deployment.md)
- [GitHub Actions secrets](./docs/github_actions_secrets.md)
- [GitHub Actions IAM user](./docs/github_actions_iam_user.md)

## Executor

- [s3_timestamp_renamer](./docs/executor/s3_timestamp_renamer.md)
- [code_deploy_performer](./docs/executor/code_deploy_performer.md)
- [cloud_front_invalidation](./docs/executor/cloud_front_invalidation.md)
