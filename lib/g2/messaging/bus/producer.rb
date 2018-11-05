module Messaging
  module Bus
    class Producer
      class << self
        def produce(value, topic:, key: nil)
          instance = new
          return instance.log(value, topic: topic, key: key) if instance.config.debug_mode

          instance.produce(value, topic: topic, key: key)
        end

        def produce!(value, topic:, key: nil)
          instance = new
          return instance.log(value, topic: topic, key: key) if instance.config.debug_mode

          instance.produce!(value, topic: topic, key: key)
        end
      end

      def produce!(*_args)
        raise NotImplementedError
      end

      def produce(*_args)
        raise NotImplementedError
      end

      def log(value, topic:, key: nil)
        config.logger.warn('*' * 100)
        config.logger.warn("Message suppressed: #{topic}; #{key}")
        config.logger.warn(value)
        config.logger.warn('*' * 100)
      end

      def config
        Messaging.config
      end
    end
  end
end
