require 'json'
require 'aws-sdk-cloudfront'
require './lib/app/executor/base'

module App
  module Executor
    class CloudFrontInvalidation < Base
      def execute
        # see: https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/CloudFront/Client.html#create_invalidation-instance_method
        client.create_invalidation(params_create_invalidation)

        logger.info(
          {
            message: 'Cloud Front Invalidation is Created.',
            distribution_id: distribution_id,
          },
        )
      end

      private

      def client
        # see: https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/CloudFront/Client.html
        @client ||= Aws::CloudFront::Client.new(
          region: config[:region],
        )
      end

      def params_create_invalidation
        {
          distribution_id: distribution_id,
          invalidation_batch: {
            paths: {
              quantity: 1,
              items: ['/*'],
            },
            caller_reference: current_str_time,
          },
        }
      end

      def distribution_id
        target = config[:code_deploy].find do |c|
          c[:application_name] == event_message[:applicationName] &&
            c[:group_name] == event_message[:deploymentGroupName]
        end

        raise StandardError, 'distribution_id is not be found.' if target.nil?

        target[:cloud_front][:distribution_id]
      end

      def event_message
        return @message unless @message.nil?

        message_str = event['Records'][0]['Sns']['Message']
        @message = JSON.parse(message_str, symbolize_names: true)
      end

      def current_str_time
        Time.now.to_i.to_s
      end
    end
  end
end
