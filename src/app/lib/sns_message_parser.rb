module App
  module Lib
    module SnsMessageParser
      def event_message
        return @event_message unless @event_message.nil?

        event_message_str = event['Records'][0]['Sns']['Message']
        @event_message = JSON.parse(event_message_str, symbolize_names: true)
      end
    end
  end
end
