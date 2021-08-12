require 'aws-sdk-codedeploy'
require './lib/app/executor/base'

module App
  module Executor
    class CodeDeployPerformer < Base
      def execute
        if code_deploy_config.nil?
          logger.info(message: "skip code deploy because #{changed_filepath} is not listed.")
        end

        # see: https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/CodeDeploy/Client.html#create_deployment-instance_method
        client.create_deployment(params_create_deployment)

        logger.info(
          message: "code deploy is performed.",
          application_name: code_deploy_config[:application_name],
          deployment_group_name: code_deploy_config[:group_name],
          bucket: config[:s3_bucket_name],
          filepath: code_deploy_config[:filepath],
        )
      end

      private

      def client
        # see: https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/CodeDeploy/Client.html
        @client ||= Aws::CodeDeploy::Client.new(
          region: config[:region],
        )
      end

      def params_create_deployment # rubocop:disable Metrics/MethodLength
        {
          application_name: code_deploy_config[:application_name],
          deployment_group_name: code_deploy_config[:group_name],
          revision: {
            revision_type: 'S3',
            s3_location: {
              bucket: config[:s3_bucket_name],
              key: code_deploy_config[:filepath],
              bundle_type: 'zip',
            },
          },
          deployment_config_name: 'CodeDeployDefault.AllAtOnce',
          description: 'Description',
          ignore_application_stop_failures: false,
          file_exists_behavior: 'OVERWRITE',
          auto_rollback_configuration: {
            enabled: false,
          },
        }
      end

      def code_deploy_config
        @code_deploy_config ||= config[:code_deploy].find do |obj|
          obj[:filepath] == changed_filepath
        end
      end

      def changed_filepath
        raise StandardError, 'too many files changed' if @event['Records'].size > 1

        @changed_filepath ||= @event['Records'].first['s3']['object']['key']
      end
    end
  end
end
