require 'redcarpet/render_strip'

module ApplicationHelper

  def markdown(text)
    md ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(escape_html: true, hard_wrap: true),
                                 autolink: true,
                                 space_after_headers: false,
                                 lax_spacing: true,
                                 tables: true)
    md.render(text).html_safe
  end

  def plain_text(text)
    plain ||= Redcarpet::Markdown.new(Redcarpet::Render::StripDown, space_after_headers: false)
    plain.render(text)
  end

  def render_editor?
    controller.controller_name == 'events' && !['index', 'show'].include?(controller.action_name)
  end

  def edit_user_path(user)
    if current_user == user
      edit_current_profile_path
    else
      edit_user_profile_path(user)
    end
  end
end
