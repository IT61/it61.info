module MailerDeliveryCommons
  def fake_delivery
    mock = double
    expect(mock).to receive(:deliver_now!)
    mock
  end
end
