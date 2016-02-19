require 'spec_helper'

describe Company::MembershipRequest do
  describe '#approve!' do
    it 'sets approved to true and saves it' do
      membership_request = create(:membership_request)

      expect { membership_request.approve! }.to change { membership_request.reload.approved }.from(false).to(true)
    end

    it 'creates company member' do
      membership_request = create(:membership_request)

      expect { membership_request.approve! }.to change(Company::Member, :count).by(1)
    end
  end

  describe '#hide!' do
    it 'sets hidden to true and saves it' do
      membership_request = create(:membership_request)

      expect { membership_request.hide! }.to change { membership_request.reload.hidden }.from(false).to(true)
    end
  end
end
