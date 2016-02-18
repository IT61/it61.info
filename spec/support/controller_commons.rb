shared_context 'http referer' do
  let(:http_referer) { 'http://previous_location/' }

  before do
    request.env['HTTP_REFERER'] = http_referer
  end
end
