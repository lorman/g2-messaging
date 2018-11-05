module Messaging
  module Bus
    module Redis
      class Runner
        attr_reader :redis_pool, :consumer_class

        Message = Struct.new(:key, :value)

        def self.run(consumer_class)
          new(consumer_class, Messaging.config.redis_pool).run
        end

        def initialize(consumer_class, redis_pool)
          @consumer_class = consumer_class
          @redis_pool = redis_pool
        end

        def run
          redis_pool.with do |r|
            r.subscribe(*consumer_class.subscriptions.map(&:topic)) do |on|
              on.message do |topic, msg|
                consumer.process(Message.new(topic, msg))
              end
            end
          end
        end

        private

        def consumer
          @consumer ||= consumer_class.new
        end
      end
    end
  end
end
