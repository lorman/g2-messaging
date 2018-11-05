# frozen_string_literal: true

module Messaging
  module Bus
    module Redis
      class Consumer < Messaging::Bus::Kafka::Consumer
        Subscription = Struct.new(:topic, :start_from_beginning)

        class << self
          def subscribes_to(*topics, start_from_beginning: false)
            apply_prefixes(topics).each do |topic|
              subscriptions << Subscription.new(topic, start_from_beginning)
            end
          end
        end

        def process(raw)
          backend.perform_later(raw.value, raw.key)
        rescue StandardError => e
          puts raw.value
          puts raw.key
          Messaging.config.error_reporter.call(e)
        end
      end
    end
  end
end
