require 'g2/messaging/bus/resolve'

describe Messaging::Bus::Resolve do
  subject { Messaging::Bus::Resolve.new(bus_name) }

  context 'with valid name' do
    let(:bus_name) { 'redis' }

    describe '#consumer' do
      it 'returns the consumer' do
        expect(subject.consumer).to eq Messaging::Bus::Redis::Consumer
      end
    end

    describe '#producer' do
      it 'returns the producer' do
        expect(subject.producer).to eq Messaging::Bus::Redis::Producer
      end
    end

    describe '#runner' do
      it 'returns the runner' do
        expect(subject.runner).to eq Messaging::Bus::Redis::Runner
      end
    end
  end

  context 'with invalid name' do
    let(:bus_name) { 'gibberish' }

    describe '#consumer' do
      it 'raises an error on initialize' do
        expect { subject }.to raise_error NameError
      end
    end
  end
end
