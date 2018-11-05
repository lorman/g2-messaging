# frozen_string_literal: true

require 'g2/messaging/bus/redis/producer'
require 'support/fake_pool'

describe Messaging::Bus::Redis::Producer do
  describe '#produce' do
    let(:redis) { double }
    let(:redis_pool) { FakePool.new(redis) }
    subject { Messaging::Bus::Redis::Producer.new(redis_pool) }

    it 'prefixes the topic, passes data through without formatting' do
      expect(redis).to receive(:publish).with('message-bus.test', x: 1)
      subject.produce({ x: 1 }, topic: 'test')
    end
  end
end
