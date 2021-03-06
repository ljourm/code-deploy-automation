require 'aws-sdk-codedeploy'
require './lib/app/executor/base'
require './app/lib/slack_notification'

module App
  module Executor
    class CodeDeployPerformer < Base
      include App::Lib::SlackNotification

      def execute
        logger.info(message: 'skip code deploy because not expected event.') unless code_deploy_config_exists?

        # see: https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/CodeDeploy/Client.html#create_deployment-instance_method
        res = client.create_deployment(params_create_deployment)

        notify_to_slack(slack_text(res.deployment_id), ENV['SLACK_WEBHOOK_URI'])

        output_info_log
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

      def code_deploy_config_exists?
        !code_deploy_config.nil?
      end

      def code_deploy_config
        @code_deploy_config unless @code_deploy_config.nil?

        event_source = event['Records'].first['eventSource']

        @code_deploy_config = case event_source
                              when 'aws:s3'
                                code_deploy_config_from_s3
                              end
      end

      def code_deploy_config_from_s3
        changed_filepath = @event['Records'].first['s3']['object']['key']

        result = config[:code_deploy].find do |obj|
          obj[:filepath] == changed_filepath
        end

        logger.info("#{filename} changed in s3  is not listed for config.") if result.nil?

        result
      end

      def slack_text(deployment_id)
        return @slack_text unless @slack_text.nil?

        <<~STR
          [Code Deploy Notification]
          :raising_hand: Code Deploy is performed manually.

          name: #{config[:region]} / #{code_deploy_config[:application_name]} / #{code_deploy_config[:group_name]}
          id: #{deployment_id}
        STR
      end

      def output_info_log
        logger.info(
          message: 'code deploy is performed.',
          application_name: code_deploy_config[:application_name],
          deployment_group_name: code_deploy_config[:group_name],
          bucket: config[:s3_bucket_name],
          filepath: code_deploy_config[:filepath],
        )
      end
    end
  end
end
