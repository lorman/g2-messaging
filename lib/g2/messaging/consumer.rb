module Messaging
  class Consumer
    class << self
      def adapter
        @adapter ||= Messaging.bus.consumer
      end

      def subscribes_to(*args)
        adapter.subscribes_to(*args)
      end

      def controller(*args)
        adapter.controller(*args)
      end
    end
  end
end
