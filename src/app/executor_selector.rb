require './app/executor/s3_timestamp_renamer'
require './app/executor/code_deploy_performer'
require './app/executor/cloud_front_invalidation'
require './app/executor/code_deploy_slack_notification'

module App
  class ExecutorSelector
    EXECUTORS = {
      # function_name(Symbol): executor(Class)
      's3-timestamp-renamer-production': App::Executor::S3TimestampRenamer,
      's3-timestamp-renamer-staging': App::Executor::S3TimestampRenamer,
      'code-deploy-performer-production': App::Executor::CodeDeployPerformer,
      'code-deploy-performer-staging': App::Executor::CodeDeployPerformer,
      'cloud-front-invalidation-production': App::Executor::CloudFrontInvalidation,
      'cloud-front-invalidation-staging': App::Executor::CloudFrontInvalidation,
      'code-deploy-slack-notification-production': App::Executor::CodeDeploySlackNotification,
      'code-deploy-slack-notification-staging': App::Executor::CodeDeploySlackNotification,
    }.freeze

    def self.executor(function_name)
      key = function_name.to_sym

      raise "undefined executor '#{function_name}'" unless EXECUTORS.key?(key)

      EXECUTORS[key]
    end
  end
end
