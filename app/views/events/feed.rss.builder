#encoding: UTF-8

xml.instruct! :xml, version: "1.0"
xml.rss version: "2.0" do
  xml.channel do
    xml.title "Мероприятия"
    xml.author "IT61"
    xml.description "Лента мероприятий IT61"
    xml.link "https://it61.info"
    xml.language "ru"

    for event in @events
      xml.item do
        xml.title event.title
        xml.author event.organizer.full_name
        xml.pubDate event.published_at.to_s(:rfc822)
        xml.link event_url(event)
        xml.guid event_url(event)
        xml.image url: event.cover.url

        xml.description do
          text = markdown(event.description)
          xml.cdata! text
        end
      end
    end
  end
end
