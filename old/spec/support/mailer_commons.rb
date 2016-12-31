shared_examples "a well tested mailer" do

  it 'renders the subject' do
    expect(mail.subject).to eql(expected_subject)
  end

  it 'renders the receiver email' do
    expect(mail.to).to eql([user.email])
  end

  it 'renders the sender email' do
    expect(mail.from).to eql([default_email])
  end

  it 'renders the reply-to email' do
    expect(mail.reply_to).to eql([replyto_email])
  end

  it 'renders asserted_body in the body of the email' do
    expected_body.each do |content|
      expect(mail.body.encoded).to match(content)
    end
  end

end
