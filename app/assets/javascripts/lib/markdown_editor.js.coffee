Lib = initNamespaces('Lib')

# Доступные опции:
#   maxLines
#   minLines
#   setUseWrapMode
#   setShowGutter
#   setShowPrintMargin
class Lib.MarkdownEditor
  constructor: (@el, @options) ->
    @options = @options || {}
    @options['maxLines'] = @options['maxLines'] || 100
    @options['minLines'] = @options['minLines'] || 20
    @options['setUseWrapMode'] = @options['setUseWrapMode'] || true
    @options['setShowGutter'] = @options['setShowGutter'] || false
    @options['setShowPrintMargin'] = @options['setShowPrintMargin'] || false

    @aceEditorDivId = if @options['name']
      "#{@options['name']}-ace-editor"
    else
      'ace-editor'
    @$el = $(@el)

    @setupEditor()

  initAce: (textarea) ->
    self = this
    $('<div>', { id: @aceEditorDivId }).insertBefore textarea

    @editor = ace.edit @aceEditorDivId
    @editor.getSession().setMode 'ace/mode/markdown'
    @editor.setTheme 'ace/theme/github'

    @editor.setOption 'maxLines', @options['maxLines']
    @editor.setOption 'minLines', @options['minLines']
    @editor.getSession().setUseWrapMode @options['setUseWrapMode']
    @editor.setAutoScrollEditorIntoView()
    @editor.renderer.setShowGutter @options['setShowGutter']
    @editor.renderer.setShowPrintMargin @options['setShowPrintMargin']

    @editor.getSession().setValue textarea.val()
    # copy back to textarea on form submit
    textarea.closest('form').submit (ev)->
      textarea.val self.editor.getSession().getValue()


  bindPreview: ->
    self = this
    @$el.find('li.preview').click (e) ->
      self.previewTabHandler(e)

  bindEdit: ->
    self = this
    @$el.find('li.edit').click ->
      self.editor.focus()

  previewTabHandler: (e) ->
    e.preventDefault()
    md = marked @editor.getValue()
    @$el.find('.md_preview').html md
    @$el.find('.nav-tabs li.preview a').tab 'show'

  setupEditor: ->
    @initAce @$el.find('textarea')
    @bindPreview()
    @bindEdit()

  @setupEditors: ->
    $('[data-markdown-editor]').each ->
      camelCasedOptions = {}
      $.each $(@).data(), (key, val)->
        camelCasedOptions[$.camelCase(key)] = val
      new Lib.MarkdownEditor(@, camelCasedOptions)

