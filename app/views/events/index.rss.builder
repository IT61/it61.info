xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title t('app_name')
    xml.description t('app_name')
    xml.link root_url
    xml.image do
      xml.url image_url('logo-it61.png')
      xml.title t('app_name')
      xml.link root_url
    end

    for event in @events
      xml.item do
        xml.title event.title
        xml.description event.description
        xml.pubDate event.published_at.to_s(:rfc822) if event.published_at?
        xml.link event_url(event)
        xml.guid event_url(event)
      end
    end
  end
end
