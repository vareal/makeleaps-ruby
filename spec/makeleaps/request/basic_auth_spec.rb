RSpec.describe Makeleaps::Request::BasicAuth do
  let(:request) { described_class.new(username, password) }
  let(:username) { 'somebody' }
  let(:password) { 'password' }

  describe '.new' do
    subject { request.connection }
    it "is an connection object" do
      expect(subject).to be_an_instance_of Faraday::Connection
    end

    describe 'headers' do
      subject { request.connection.headers }
      let(:credential) { Base64.strict_encode64("#{username}:#{password}") }

      it { is_expected.to match a_hash_including(
            'Authorization' => "Basic #{credential}",
            "Accept"        => "application/json"
          ) }
    end
  end

  describe '#authenticate!' do
    subject { request.authenticate! }

    context 'authorized client' do
      let(:username) { 'valid_username' }
      let(:password) { 'correct_password' }

      it 'is an instance of Makeleaps::Response::TokenStore' do
        VCR.use_cassette('request/basic_auth/authorized_client') do
          expect(subject).to be_an_instance_of(Makeleaps::Response::TokenStore)
        end
      end

      describe 'response body' do
        before do
          VCR.use_cassette('request/basic_auth/authorized_client') do
            @token_store = request.authenticate!
          end
        end

        subject { @token_store.body }

        it 'receives a token' do
          expect(subject).to include 'access_token'
        end

        it 'receives auth information' do
          expect(subject).to match a_hash_including(
            "expires_in"=>36000,
            "token_type"=>"Bearer",
            "scope"=>"read write"            
          )
        end
      end
    end

    context 'invalid client' do
      let(:username) { 'invalid_username' }
      let(:password) { 'a_random_password' }

      # TODO: set appropreate error class
      it 'raises error' do
        VCR.use_cassette('request/basic_auth/invalid_client') do
          expect{ subject }.to raise_error(Makeleaps::APIError)
        end
      end
    end
  end

  describe '#revoke!' do
    let(:username) { 'valid_username' }
    let(:password) { 'correct_password' }

    before do
      VCR.use_cassette('request/basic_auth/authorized_client') do
        @token_store = request.authenticate!
      end
    end

    subject { request.revoke!(@token_store.access_token) }

    it 'can be revoked succesfully' do
      VCR.use_cassette('request/basic_auth/revocation') do
        expect(subject).to satisfy { |res| res.status == 200 }
      end
    end
  end
end
