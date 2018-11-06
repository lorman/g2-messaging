module Messaging
  class Deliver
    class << self
      def perform_now(message, topic:, key: nil)
        validate! message

        Messaging.produce!(wrapped(message).to_json, topic: topic, key: key)
      end

      def perform_later(message, topic:, key: nil)
        validate! message

        Messaging.produce(wrapped(message).to_json, topic: topic, key: key)
      end

      def validate!(message)
        raise Messaging::ValidationError, message.errors.full_messages.join("\n") unless message.valid?
      end

      def wrapped(message)
        {
          schema_model: message.class.name.underscore,
          model: message.class.name.demodulize,
          data: message.as_schema_hash
        }
      end
    end
  end
end
