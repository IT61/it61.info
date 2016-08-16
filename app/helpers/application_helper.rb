module ApplicationHelper
  # rubocop:disable Rails/OutputSafety
  def markdown(text)
    md ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(escape_html: true, hard_wrap: true),
                                   autolink: true,
                                   space_after_headers: false,
                                   lax_spacing: true,
                                   tables: true)
    raw(md.render(text))
  end

  def plain_text(text)
    plain ||= Redcarpet::Markdown.new(Redcarpet::Render::StripDown, space_after_headers: false)
    plain.render(text)
  end

  def render_editor?
    controller.controller_name == "events" && !["index", "show"].include?(controller.action_name)
  end

  def title
    if content_for?(:title)
      content_for :title
    else
      # t("pages.#{controller_path.tr('/', '.')}")
    end
  end
end
