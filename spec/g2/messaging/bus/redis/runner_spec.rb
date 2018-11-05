require 'spec_helper'
require 'support/fake_pool'

describe Messaging::Bus::Redis::Runner do
  subject { Messaging::Bus::Redis::Runner.new(consumer_class, redis_pool) }
  let(:consumer_class) do
    Class.new(Messaging::Bus::Redis::Consumer) do
      subscribes_to 'test'
    end
  end
  let(:redis_pool) { FakePool.new(redis) }

  let(:fake_redis) do
    Class.new do
      attr_reader :topics

      def initialize(messages = [])
        @messages = messages
      end

      def subscribe(*topics, &block)
        @topics = topics
        block.call(self)
      end

      def message(&block)
        @messages.each do |(topic, message)|
          block.call(topic, message)
        end
      end
    end
  end

  describe '#run' do
    context 'with a message' do
      let(:message) { Messaging::Bus::Redis::Runner::Message.new('message-bus.test', { 'x' => 1 }.to_json) }
      let(:redis) { fake_redis.new([[message.key, message.value]]) }

      it 'passes json to consumer#process' do
        expect_any_instance_of(consumer_class).to receive(:process).with(message)
        subject.run
      end

      it 'subscribes to consumer topics' do
        expect_any_instance_of(consumer_class).to receive(:process)
        subject.run
        expect(redis.topics).to eq ['message-bus.test']
      end
    end
  end
end
