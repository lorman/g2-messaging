require 'g2/messaging/bus/kafka/producer'

describe Messaging::Bus::Kafka::Producer do
  subject { Messaging::Bus::Kafka::Producer }

  let(:producer) { double(produce: true, deliver_messages: true, shutdown: false) }
  let(:kafka_client) { double(async_producer: producer, producer: producer) }

  before do
    allow(subject).to receive(:kafka_client).and_return(kafka_client)
  end

  after do
    subject.reset
  end

  it 'should have prepared cleanup' do
    expect(subject).to receive(:prepare_cleanup).and_call_original.at_least(1)
    subject.async_pool
  end

  it 'should have created ConnectionPool' do
    expect(ConnectionPool).to receive(:new).and_call_original.at_least(1)
    subject.async_pool
  end

  context 'when ruby' do
    before { stub_const('RUBY_ENGINE', 'ruby') }

    it 'should trap signals' do
      expect(subject).to receive(:shut_your_trap).with('QUIT').at_least(1).and_call_original
      expect(subject).to receive(:shut_your_trap).with('TERM').at_least(1).and_call_original
      expect(subject).to receive(:shut_your_trap).with('INT').at_least(1).and_call_original
      subject.async_pool
    end
  end

  context 'when jruby' do
    before { stub_const('RUBY_ENGINE', 'jruby') }

    it 'should trap signals' do
      expect(subject).not_to receive(:shut_your_trap).with('QUIT').and_call_original
      expect(subject).not_to receive(:shut_your_trap).with('TERM').and_call_original
      expect(subject).to receive(:shut_your_trap).with('INT').at_least(1).and_call_original
      subject.async_pool
    end
  end
end
