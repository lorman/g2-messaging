# frozen_string_literal: true

require 'racecar'

module Messaging
  module Bus
    module Kafka
      class Consumer < Racecar::Consumer
        class << self
          attr_accessor :backend

          def subscribes_to(*topics, start_from_beginning: false, max_bytes_per_partition: 1 * 1024 * 1024)
            prefixed_topics = apply_prefixes(topics)
            super(*prefixed_topics,
                  start_from_beginning: start_from_beginning,
                  max_bytes_per_partition: max_bytes_per_partition)
          end

          def controller(klass)
            self.backend = klass
          end

          def backend
            @backend ||= Messaging::Backends::Inline
          end

          def apply_prefixes(topics)
            topics.map { |i| "#{Messaging.config.prefix}#{i}" }
          end
        end

        def process(raw)
          backend.perform_later(encoded_value(raw.value), raw.key)
        rescue StandardError => e
          puts raw.value
          puts raw.key
          Messaging.config.error_reporter.call(e)
        end

        private

        def encoded_value(value)
          (value || '').force_encoding('utf-8')
        end

        def backend
          self.class.backend
        end
      end
    end
  end
end
