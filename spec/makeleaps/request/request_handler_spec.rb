RSpec.describe Makeleaps::Request::RequestHandler do

  let(:handler)    { described_class.new(connection) }
  let(:connection) { double(:connection).tap { |mock| allow(mock).to receive(method).and_return(response) } }
  let(:response)   { double(:response).tap   { |mock|
                      allow(mock).to receive(:status).and_return(status_code)
                      allow(mock).to receive(:resource).and_return({foo: :bar}.to_json) }
                   }

  before do
    allow(Makeleaps::Response::Wrapper).to receive(:new).with(response)
  end

  describe '#get' do
    subject { handler.get(:foo, :bar) { |req| req.body='something' } }
    let(:method) { :get }

    context 'with valid response' do
      let(:status_code) { 200 }

      it 'raises no errors' do
        expect { subject }.not_to raise_error
      end

      it 'delegates its method to connection' do
        expect(connection).to receive(method).with(:foo, :bar).once
        subject
      end
    end

    context 'with invalid response' do
      let(:status_code) { 301 }

      it 'raises an error' do
        # TODO: set appropreate errors
        expect { subject }.to raise_error(Makeleaps::APIError)
      end
    end
  end

  describe '#post' do
    subject { handler.post(:foo, :bar) { |req| req.body='something' } }
    let(:method) { :post }

    context 'with valid response' do
      let(:status_code) { 201 }

      it 'raises no errors' do
        expect { subject }.not_to raise_error
      end

      it 'delegates its method to connection' do
        expect(connection).to receive(method).with(:foo, :bar).once
        subject
      end
    end

    context 'with invalid response' do
      let(:status_code) { 500 }

      it 'raises an error' do
        # TODO: set appropreate errors
        expect { subject }.to raise_error(Makeleaps::APIError)
      end
    end
  end

  describe '#patch' do
    subject { handler.patch(:foo, :bar) { |req| req.body='something' } }
    let(:method) { :patch }

    context 'with valid response' do
      let(:status_code) { 200 }

      it 'raises no errors' do
        expect { subject }.not_to raise_error
      end

      it 'delegates its method to connection' do
        expect(connection).to receive(method).with(:foo, :bar).once
        subject
      end
    end

    context 'with invalid response' do
      let(:status_code) { 404 }

      it 'raises an error' do
        # TODO: set appropreate errors
        expect { subject }.to raise_error(Makeleaps::APIError)
      end
    end
  end

  describe '#put' do
    subject { handler.put(:foo, :bar) { |req| req.body='something' } }
    let(:method) { :put }

    context 'with valid response' do
      let(:status_code) { 200 }

      it 'raises no errors' do
        expect { subject }.not_to raise_error
      end

      it 'delegates its method to connection' do
        expect(connection).to receive(method).with(:foo, :bar).once
        subject
      end
    end

    context 'with invalid response' do
      let(:status_code) { 404 }

      it 'raises an error' do
        # TODO: set appropreate errors
        expect { subject }.to raise_error(Makeleaps::APIError)
      end
    end
  end

  describe '#delete' do
    subject { handler.delete(:foo, :bar) }
    let(:method) { :delete }

    context 'with valid response' do
      let(:status_code) { 204 }

      it 'raises no errors' do
        expect { subject }.not_to raise_error
      end

      it 'delegates its method to connection' do
        expect(connection).to receive(method).with(:foo, :bar).once
        subject
      end
    end

    context 'with invalid response' do
      let(:status_code) { 500 }

      it 'raises an error' do
        # TODO: set appropreate errors
        expect { subject }.to raise_error(Makeleaps::APIError)
      end
    end
  end

  describe '#options' do
    let(:connection) { double(:connection).tap { |mock| allow(mock).to receive(:run_request).with(:options, url, nil, nil).and_return(response) } }
    let(:url) { 'https://www.example.com/api/v1/endpoint/' }
    subject { handler.options(url) }

    context 'with valid response' do
      let(:status_code) { 200 }

      it 'raises no errors' do
        expect { subject }.not_to raise_error
      end

      it 'delegates its method to connection' do
        expect(connection).to receive(:run_request).with(:options, url, nil, nil).once
        subject
      end
    end

    context 'with invalid response' do
      let(:status_code) { 404 }

      it 'raises an error' do
        # TODO: set appropreate errors
        expect { subject }.to raise_error(Makeleaps::APIError)
      end
    end
  end
end
