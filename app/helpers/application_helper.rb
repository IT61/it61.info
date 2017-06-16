module ApplicationHelper

  def default_meta_image
    {
      _: asset_url("share.png"),
      width: 1200,
      height: 630,
    }
  end

  def default_meta_tags
    {
      site: Settings.community.title,
      reverse: true,
      separator: raw("&ndash;"),
      description: Settings.community.description,
      image_src: asset_url("share.png"),
      og: {
        site_name: :site,
        title: :title,
        description: :description,
        url: root_url,
        locale: "ru_RU",
        type: "website",
        image: default_meta_image,
      },
      twitter: {
        image: asset_url("share.png"),
        card: "summary_large_image",
        site: "it_rostov",
        title: :title,
        description: :description,
      },
    }
  end

  def markdown(text)
    raw(MarkdownService.render_plain(text))
  end

  def plain_text(text)
    MarkdownService.render_plain(text)
  end

  def social_networks
    Dir["#{Rails.root}/app/views/application/widgets/*"].sort_by { |file| file.scan(/\d+/).last.to_i }
  end
end
