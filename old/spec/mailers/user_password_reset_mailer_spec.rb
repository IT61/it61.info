require 'spec_helper'

describe UserPasswordResetMailer do
  let(:default_email) { 'noreply@it61.info' }
  let(:replyto_email) { 'reply@it61.info' }
  let(:user) { build_stubbed :user, :with_reset_password_token }

  describe 'reset_password_email' do
    let(:mail) { UserPasswordResetMailer.reset_password_email(user) }

    let(:expected_subject) { 'Восстановление пароля' }
    let(:expected_body) { [user.reset_password_token] }

    it_behaves_like 'a well tested mailer'
  end

end
