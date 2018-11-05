require 'g2/messaging/bus/producer'

module Messaging
  module Bus
    module Redis
      class Producer < Messaging::Bus::Producer
        attr_reader :redis_pool

        def initialize(redis_pool = config.redis_pool)
          @redis_pool = redis_pool
        end

        def produce!(value, topic:, key: nil)
          redis_pool.with { |r| r.publish "#{config.prefix}#{topic}", value }
        end

        def produce(*args)
          produce!(*args)
        end
      end
    end
  end
end
