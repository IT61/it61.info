require 'spec_helper'

describe ApplicationController, type: :controller do
  describe 'handling CanCan::AccessDenied exceptions' do
    controller do
      def index
        raise CanCan::AccessDenied
      end
    end

    before do
      get :index
    end

    it { is_expected.to redirect_to(root_url) }
    it { is_expected.to set_flash[:error] }
  end
end
