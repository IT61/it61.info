# encoding: UTF-8

xml.instruct! :xml, version: "1.0"
xml.rss version: "2.0" do
  xml.channel do
    xml.title "Мероприятия"
    xml.description "Лента мероприятий IT61"
    xml.link "https://it61.info"
    xml.language "ru"

    for event in @events
      xml.item do
        xml.title event.title
        xml.link event_url(event)
        xml.pubDate event.published_at.to_s(:rfc822)
        xml.guid event_url(event)

        xml.description do
          text = markdown(event.description)
          xml.cdata! text
        end
      end
    end
  end
end
