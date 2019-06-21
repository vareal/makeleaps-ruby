RSpec.describe Makeleaps::Request::URLManager do

  let(:manager) { described_class.new }

  describe '#set_partner!' do
    subject { manager.set_partner!(partner_mid) }
    let(:partner_mid) { 123456 }

    it 'sets partner_mid' do
      expect { subject }.to change { manager.partner_mid }.from(nil).to(partner_mid)
    end
  end

  describe 'build_url_for' do
    subject { manager.build_url_for(resource_or_url, mid) }

    context 'with string' do
      let(:mid) { nil }
      let(:resource_or_url) { 'https://foo.example.com/api/' }
      it { is_expected.to eq resource_or_url }
    end

    context 'partner' do
      let(:mid) { 54321 }
      let(:resource_or_url) { :partner }
      it { is_expected.to eq 'https://api.makeleaps.com/api/partner/54321/' }
    end

    context 'currency' do
      let(:mid) { nil }
      let(:resource_or_url) { :currency }
      it { is_expected.to eq 'https://api.makeleaps.com/api/currency/' }
    end

    context 'client contact' do
      before do
        manager.set_partner!(11111)
      end

      let(:mid) { 123456 }
      let(:resource_or_url) { :client_contact }
      it { is_expected.to eq 'https://api.makeleaps.com/api/partner/11111/client/123456/contact/' }
    end

    context 'other endpoint names' do
      before do
        manager.set_partner!(321321321)
      end

      let(:mid) { 777777 }
      let(:resource_or_url) { :document }
      it { is_expected.to eq 'https://api.makeleaps.com/api/partner/321321321/document/777777/' }
    end
  end
end
