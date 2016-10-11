module ApplicationHelper
  def markdown(text)
    # rubocop:disable Rails/OutputSafety
    raw(MarkdownService.render_markdown(text))
  end

  def plain_text(text)
    MarkdownService.render_plain(text)
  end

  def render_editor?
    controller.controller_name == "events" && !["index", "show"].include?(controller.action_name)
  end
end
