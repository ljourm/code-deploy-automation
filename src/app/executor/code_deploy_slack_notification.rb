require 'net/http'
require './lib/app/executor/base'
require './app/lib/sns_message_parser'

module App
  module Executor
    class CodeDeploySlackNotification < Base
      include App::Lib::SnsMessageParser

      HTTP_HEADERS = { 'Content-Type' => 'application/json' }.freeze

      def execute # rubocop:disable Metrics/MethodLength
        logger.debug(
          {
            slack_text: slack_text,
          },
        )

        response = post_message

        logger.info(
          message: 'post result',
          response: {
            code: response.code,
            body: response.body,
          },
        )
      end

      private

      def post_message
        uri = URI.parse(ENV['SLACK_WEBHOOK_URI'])
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.post(uri.path, { text: slack_text }.to_json, HTTP_HEADERS)
      end

      def slack_text # rubocop:disable Metrics/MethodLength, Metrics/AbcSize:
        return @slack_text unless @slack_text.nil?

        text = <<~STR
          [Code Deploy Notification]
          name: #{event_message[:region]} / #{event_message[:applicationName]} / #{event_message[:deploymentGroupName]}
          id: #{event_message[:deploymentId]}

          created_at: #{event_message[:createTime]}
          completed_at: #{event_message[:completeTime]}

          trigger: #{event_message[:eventTriggerName]}
          status: #{event_message[:status]}
        STR

        @slack_text = if exists_error_information?
                        "#{text}\n\n#{error_information}"
                      else
                        text
                      end
      end

      def exists_error_information?
        event_message.key?(:errorInformation)
      end

      def error_information
        error_information = JSON.parse(event_message[:errorInformation], symbolize_names: true)

        <<~STR
          error information:
            code: #{error_information[:ErrorCode]}
            message: #{error_information[:ErrorMessage]}
            rollback: #{error_information[:rollbackInformation]}
        STR
      end
    end
  end
end
