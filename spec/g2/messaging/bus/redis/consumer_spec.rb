require 'g2/messaging/bus/redis/consumer'

describe Messaging::Bus::Kafka::Consumer do
  subject { consumer }

  let(:consumer) do 
    Class.new(Messaging::Bus::Redis::Consumer) do
    end
  end

  describe '#subscribes_to' do
    it 'prefixes topics' do
      subject.subscribes_to 'test'
      expect(subject.subscriptions.size).to eq 1
      expect(subject.subscriptions.first.topic).to eq 'message-bus.test'
    end

    it 'defaults start_from_beginning to false' do
      subject.subscribes_to 'new-test'
      expect(subject.subscriptions.size).to eq 1
      expect(subject.subscriptions.first.topic).to eq 'message-bus.new-test'
      expect(subject.subscriptions.first.start_from_beginning).to eq false
    end
  end

  describe '#process' do
    let(:message) { double(value: 'val', key: 'key') }
    it 'calls perform_later on the provided backend' do
      expect(Messaging::Backends::Inline).to receive(:perform_later).with(message.value, message.key)
      subject.new.process(message)
    end
  end
end
