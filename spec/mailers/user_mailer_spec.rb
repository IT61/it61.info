require 'spec_helper'

describe UserMailer do
  let(:default_email) { 'noreply@it61.info' }
  let(:replyto_email) { 'reply@it61.info' }
  let(:user) { FactoryGirl.build_stubbed :reset_password_user }

  describe 'reset_password_email' do
    let(:mail) { UserMailer.reset_password_email(user) }

    let(:expected_subject) { 'Восстановление пароля' }
    let(:expected_body) { [user.reset_password_token] }

    it_behaves_like 'a well tested mailer'
  end

end