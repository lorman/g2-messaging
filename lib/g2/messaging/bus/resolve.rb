require 'g2/messaging/bus/kafka/consumer'
require 'g2/messaging/bus/kafka/producer'
require 'g2/messaging/bus/kafka/runner'

require 'g2/messaging/bus/redis/consumer'
require 'g2/messaging/bus/redis/producer'
require 'g2/messaging/bus/redis/runner'

module Messaging
  module Bus
    class Resolve
      attr_reader :bus_name

      def initialize(bus_name)
        @bus_name = bus_name
        namespace
      end

      def consumer
        namespace::Consumer
      end

      def producer
        namespace::Producer
      end

      def runner
        namespace::Runner
      end

      private

      def namespace
        @namespace ||= Messaging::Bus.const_get(bus_name.to_s.camelize)
      end
    end
  end
end
