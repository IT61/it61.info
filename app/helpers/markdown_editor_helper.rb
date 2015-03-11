module MarkdownEditorHelper
  # Доступные опции:
  #   max_lines
  #   min_lines
  #   set_use_wrap_mode
  #   set_show_gutter
  #   set_show_print_margin
  def markdown_text_area(form_builder, field, options = {})
    options[:data] ||= {}
    data = { 'markdown-editor': true, name: field }.merge(options[:data])

    content_tag(:div, class: 'form-group markdown-editor', data: data) do
      concat markdown_text_area_tabs(form_builder, field, options)
      concat markdown_text_area_tabs_content(form_builder, field, options)
      concat markdown_text_help_block.html_safe
    end
  end

  def markdown_text_area_tabs(form_builder, field, options = {})
    content_tag(:ul, class: 'nav nav-tabs') do
      concat(content_tag(:li, class: 'edit active') do
        label1 = form_builder.object.class.human_attribute_name(field)
        link_to label1, "##{field}-edit", 'data-toggle': 'tab'
      end)

      concat(content_tag(:li, class: 'preview') do
        link_to t('markdown_editor.preview'), "##{field}-preview", 'data-toggle': 'tab'
      end)
    end
  end

  def markdown_text_area_tabs_content(form_builder, field, options = {})
    content_tag(:div, class: 'tab-content') do
      concat(content_tag(:div, id: "#{field}-edit", class: 'tab-pane active') do
        form_builder.text_area field, class: 'hidden'
      end)

      concat(content_tag(:div, id: "#{field}-preview", class: 'tab-pane') do
        content_tag(:div, '', class: 'md_preview')
      end)
    end
  end

  def markdown_text_help_block
    content_tag(:p, class: 'text-muted text-right small') do
      markdown_home = 'https://ru.wikipedia.org/wiki/Markdown'
      markup = t('markdown_editor.help_block')
      markup += ' '
      markup += link_to('Markdown', markdown_home, target: '_blank')
      markup.html_safe
    end
  end
end
