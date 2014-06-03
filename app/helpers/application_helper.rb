module ApplicationHelper

  def markdown(text)
    md ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(filter_html: true),
                                 autolink: true,
                                 space_after_headers: true,
                                 tables: true)
    md.render(text).html_safe
  end

  def render_editor?
    controller.controller_name == 'events' &&
    (controller.action_name == 'new' || controller.action_name == 'edit')
  end
end
