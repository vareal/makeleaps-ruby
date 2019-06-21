RSpec.describe Makeleaps::Request::Base do

  describe '.new' do
    let(:request) { described_class.new }
    subject { request.connection }
    it "is an connection object" do
      expect(subject).to be_an_instance_of Faraday::Connection
    end
  end
end
