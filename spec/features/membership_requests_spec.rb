require 'spec_helper'

feature 'Membership requests pagination' do
  scenario 'user gets paginated results' do
    @user = create :user, password: 'secret', password_confirmation: 'secret'
    login_user @user, user_session_url

    @company = create(:company, founder: @user)
    @request1 = create(:membership_request, company: @company)
    @request2 = create(:membership_request, company: @company)

    visit company_membership_requests_url(@company, per: 1)

    expect(page).to have_css('.pagination')
    expect(page).to have_content(@request1.user.full_name)
    expect(page).not_to have_content(@request2.user.full_name)

    visit company_membership_requests_url(@company)

    expect(page).not_to have_css('.pagination')
    expect(page).to have_content(@request1.user.full_name)
    expect(page).to have_content(@request2.user.full_name)
  end
end
