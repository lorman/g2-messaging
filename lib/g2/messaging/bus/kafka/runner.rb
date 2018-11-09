module Messaging
  module Bus
    module Kafka
      class Runner
        attr_reader :consumer_class

        Message = Struct.new(:key, :value)

        def self.run(consumer_class)
          new(consumer_class).run
        end

        def initialize(consumer_class)
          @consumer_class = consumer_class
        end

        def run
          Messaging.start_racecar!
          Racecar.config.load_consumer_class(consumer_class)
          Racecar.config.validate!
          Racecar.run(consumer)
        end

        private

        def consumer
          @consumer ||= consumer_class.new
        end
      end
    end
  end
end
