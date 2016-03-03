require 'spec_helper'

describe AdminMailer do
  let(:default_email) { 'noreply@it61.info' }
  let(:replyto_email) { 'reply@it61.info' }
  let(:user)         { FactoryGirl.build_stubbed(:user) }
  let(:another_user) { FactoryGirl.build_stubbed(:user) }

  context 'request_to_membership' do
    let(:company) { FactoryGirl.build_stubbed(:company) }
    let(:mail) { described_class.request_to_membership(user, company, another_user) }

    let(:expected_body) { [company.title, another_user.full_name] }
    let(:expected_subject) { "Новая заявка на членство в «#{company.title}»" }

    it_behaves_like 'a well tested mailer'
  end

  context 'new_company_user' do
    let(:mail) { described_class.new_company_user(user, another_user) }

    let(:expected_body) { [user.full_name, another_user.full_name] }
    let(:expected_subject) { "Добавлен новый пользователь «#{another_user.full_name}»" }

    it_behaves_like 'a well tested mailer'
  end

  context 'delete_user_from_company' do
    let(:mail) { described_class.delete_user_from_company(user, another_user) }

    let(:expected_body) { [user.full_name] }
    let(:expected_subject) { "Удален пользователь «#{another_user.full_name}»" }

    it_behaves_like 'a well tested mailer'
  end

  context 'changing_user_permissions' do
    let(:mail) { described_class.changing_user_permissions(user, another_user) }

    let(:expected_body) { [user.full_name] }
    let(:expected_subject) { "Смена прав для пользователя - «#{another_user.full_name}»" }

    it_behaves_like 'a well tested mailer'
  end
end
