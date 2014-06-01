module ApplicationHelper

  def markdown(text)
    md ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(filter_html: true, hard_wrap: true),
                                 autolink: true,
                                 space_after_headers: true,
                                 tables: true)
    md.render(markup)
  end
end
