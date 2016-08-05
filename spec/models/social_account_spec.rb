require "rails_helper"

RSpec.describe SocialAccount, type: :model do

  describe "public class methods" do
    context "responds to its methods" do
      it { expect(SocialAccount).to respond_to(:link_for) }
    end
  end

end
