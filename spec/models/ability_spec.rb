require 'spec_helper'
require 'cancan/matchers'

describe 'User' do
  describe 'abilities' do
    subject(:ability) { Ability.new(user) }
    let(:user) { create(:user) }

    context 'when is a guest' do
      let(:user) { nil }
      let(:company_member) { build_stubbed(:company_member) }

      it { is_expected.to be_able_to(:view, company_member) }
    end

    context 'when is a signed in user' do
      let(:membership_request) { build_stubbed(:membership_request) }
      let(:company_member) { build_stubbed(:company_member) }

      it { is_expected.to be_able_to(:view, membership_request) }
      it { is_expected.to be_able_to(:create, membership_request) }
      it { is_expected.to be_able_to(:view, company_member) }
    end

    context 'when is a site admin' do
      let(:user) { create(:admin) }
      let(:company) { build_stubbed(:company) }
      let(:membership_request) { build_stubbed(:membership_request) }

      it { is_expected.to be_able_to(:manage, company) }
      it { is_expected.to be_able_to(:manage, membership_request) }
    end

    context 'when is a company member' do
      let(:company_member) { create(:company_member, user: user) }
      let(:other_member) { build_stubbed(:company_member, company: company_member.company) }

      it { is_expected.to be_able_to(:destroy, company_member) }
      it { is_expected.not_to be_able_to(:update, company_member) }
      it { is_expected.not_to be_able_to(:destroy, other_member) }
    end

    context 'when is a company admin' do
      let(:company_admin) { create(:company_member, :admin, user: user) }
      let(:other_member) { build_stubbed(:company_member, company: company_admin.company) }

      it { is_expected.not_to be_able_to(:update, other_member) }
      it { is_expected.to be_able_to(:destroy, other_member) }
    end

    context 'when is a company founder' do
      let(:company) { build_stubbed(:company, founder: user) }
      let(:membership_request) { build_stubbed(:membership_request, company: company) }
      let(:other_member) { build_stubbed(:company_member, company: company) }

      it { is_expected.to be_able_to(:view, company) }

      it { is_expected.to be_able_to(:approve, membership_request) }
      it { is_expected.to be_able_to(:hide, membership_request) }
      it { is_expected.to be_able_to(:update, other_member) }
    end
  end
end
