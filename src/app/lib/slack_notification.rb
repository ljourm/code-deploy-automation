module App
  module Lib
    module SlackNotification
      HTTP_HEADERS = { 'Content-Type' => 'application/json' }.freeze

      def notify_to_slack(text, webhook_uri)
        uri = URI.parse(webhook_uri)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true

        response = http.post(uri.path, { text: text }.to_json, HTTP_HEADERS)

        unless response.code == 200
          raise StandardError,
                "slack notification is failed. code: #{response.code}, body: #{response.body}"
        end

        response
      end
    end
  end
end
