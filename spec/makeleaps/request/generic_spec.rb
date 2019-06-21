RSpec.describe Makeleaps::Request::Generic do

  let(:request) { described_class.new(access_token) }
  let(:access_token) { 'qwertyuiopp1234567890zxcvbnm' }

  describe '.new' do
    describe 'handler' do
      subject { request.handler }

      it "is an RequestHandler object" do
        expect(subject).to be_an_instance_of Makeleaps::Request::RequestHandler
      end

      it "has connection object" do
        expect(subject.connection).to be_an_instance_of Faraday::Connection
      end
    end

    describe 'url_manager' do
      subject { request.url_manager }

      it "is an URLManager object" do
        expect(subject).to be_an_instance_of Makeleaps::Request::URLManager
      end
    end

    describe 'request headers' do
      subject { request.handler.connection.headers }

      it { is_expected.to match a_hash_including(
            'Authorization' => "Bearer #{access_token}",
            "Accept"        => "application/json"
          ) }
    end
  end

  describe '#find_partner_by' do
    subject { request.find_partner_by(name: name) }
    let(:name) { 'mock industory co ltd.' }

    it 'returns a list contains partner urls' do
      VCR.use_cassette('request/generic/partners') do
        expect(subject).to match a_hash_including("url"=>"https://api.makeleaps.com/api/partner/123456789123456789/")
      end
    end
  end

  describe '#set_partner!' do
    subject { request.set_partner!(name: name) }
    let(:name) { 'mock industory co ltd.' }

    it 'sets mid to url_manager' do
      VCR.use_cassette('request/generic/partners') do
        expect { subject }.to change { request.url_manager.partner_mid }.to('123456789123456789')
      end
    end
  end

  describe '#each_page' do
    pending('TODO')
  end

  describe '#get' do
    before do
      request.url_manager.set_partner! '123456789123456789'
    end

    subject { request.get :document }

    it 'returns a wrapper instance' do
      VCR.use_cassette('request/generic/documents') do
        expect(subject).to be_an_instance_of(Makeleaps::Response::Wrapper)
      end
    end

    it 'returns a list contains document urls' do
      VCR.use_cassette('request/generic/documents') do
        expect(subject.resource.content).to contain_exactly(
          a_hash_including("url"=>"https://api.makeleaps.com/api/partner/123456789123456789/document/1111111111111111111/"),
          a_hash_including("url"=>"https://api.makeleaps.com/api/partner/123456789123456789/document/9999999999999999999/"),
        )
      end
    end
  end
end
