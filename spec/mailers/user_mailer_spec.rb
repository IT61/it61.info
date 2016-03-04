require 'spec_helper'

describe UserMailer do
  let(:default_email) { 'noreply@it61.info' }
  let(:replyto_email) { 'reply@it61.info' }
  let(:user)    { FactoryGirl.build_stubbed(:user) }
  let(:company) { FactoryGirl.build_stubbed(:company) }

  context 'notice_about_request' do
    let(:mail) { described_class.notice_about_request(user, company) }

    let(:expected_body) { [company.title] }
    let(:expected_subject) { "Отправлен запрос на добавление в «#{company.title}»" }

    it_behaves_like 'a well tested mailer'
  end

  context 'notice_about_accept' do
    let(:mail) { described_class.notice_about_accept(user, company) }
    let(:expected_body) { [company.title] }
    let(:expected_subject) { "Подтвержден Ваш запрос на добавление в «#{company.title}»" }

    it_behaves_like 'a well tested mailer'
  end

  context 'notice_about_delete' do
    let(:mail) { described_class.notice_about_delete(user, company) }
    let(:expected_body) { [company.title] }
    let(:expected_subject) { "Вас удалили из «#{company.title}»" }

    it_behaves_like 'a well tested mailer'
  end
end
