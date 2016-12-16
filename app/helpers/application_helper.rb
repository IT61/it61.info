module ApplicationHelper
  def markdown(text)
    raw(MarkdownService.render_markdown(text))
  end

  def plain_text(text)
    MarkdownService.render_plain(text)
  end

  def social_networks
    Dir["#{Rails.root}/app/views/shared/widgets/*"].sort_by {|file| file.scan(/\d+/).last.to_i }
  end
end
