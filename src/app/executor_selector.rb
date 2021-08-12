require './app/executor/s3_timestamp_renamer'
require './app/executor/code_deploy_performer'
require './app/executor/cloud_front_invalidation'

module App
  class ExecutorSelector
    EXECUTORS = {
      # function_name(Symbol): executor(Class)
      's3-timestamp-renamer': App::Executor::S3TimestampRenamer,
      'code-deploy-performer': App::Executor::CodeDeployPerformer,
      'cloud-front-invalidation': App::Executor::CloudFrontInvalidation,
    }.freeze

    def self.executor(function_name)
      key = function_name.to_sym

      raise "undefined executor '#{function_name}'" unless EXECUTORS.key?(key)

      EXECUTORS[key]
    end
  end
end
