require 'spec_helper'
require 'cancan/matchers'

describe 'User' do
  describe 'abilities' do
    subject(:ability) { Ability.new(user) }
    let(:user) { nil }

    context 'when is an admin' do
      let(:user) { create(:admin) }
      let(:company) { build_stubbed(:company) }
      let(:membership_request) { build_stubbed(:membership_request) }

      it { is_expected.to be_able_to(:manage, company) }
      it { is_expected.to be_able_to(:manage, membership_request) }
    end

    context 'when is a company founder' do
      let(:user) { create(:user) }
      let(:company) { build_stubbed(:company, founder: user) }
      let(:membership_request) { build_stubbed(:membership_request, company: company) }

      it { is_expected.to be_able_to(:view, company) }

      it { is_expected.to be_able_to(:approve, membership_request) }
      it { is_expected.to be_able_to(:hide, membership_request) }
    end

    context 'when is a member' do
      let(:user) { create(:user) }
      let(:membership_request) { build_stubbed(:membership_request) }

      it { is_expected.to be_able_to(:create, membership_request) }
    end
  end
end
