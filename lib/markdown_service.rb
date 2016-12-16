require "redcarpet/render_strip"

class MarkdownService
  def self.render_markdown(text)
    @md ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(escape_html: true, hard_wrap: true),
                                    autolink: true,
                                    space_after_headers: false,
                                    lax_spacing: true,
                                    tables: true)
    @md.render(text)
  end

  def self.render_plain(text)
    @plain ||= Redcarpet::Markdown.new(Redcarpet::Render::StripDown, space_after_headers: false)
    @plain.render(text)
  end
end
