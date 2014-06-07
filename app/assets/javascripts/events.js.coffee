it61 = window.it61 || {}

initMarked = ->
  marked.setOptions
    gfm: true
    tables: true
    breaks: true
    pedantic: true
    sanitize: true
    smartLists: false
    smartypants: false

initAce = (textarea) ->
  $('<div>', { id: 'ace-editor' }).insertBefore textarea

  editor = ace.edit 'ace-editor'
  editor.getSession().setMode 'ace/mode/markdown'
  editor.setTheme 'ace/theme/github'

  editor.setOption 'maxLines', 100
  editor.setOption 'minLines', 20
  editor.getSession().setUseWrapMode true
  editor.setAutoScrollEditorIntoView()
  editor.renderer.setShowGutter false

  editor.getSession().setValue textarea.val()
  # copy back to textarea on form submit
  textarea.closest('form').submit ->
    textarea.val editor.getSession().getValue()
  # share editor instance
  it61.editor = editor

bindPreview = ->
  $('ul.event-description li.preview').click (e) ->
    previewTabHandler e

bindEdit = ->
  $('ul.event-description li.edit').click (e) ->
    it61.editor.focus()


previewTabHandler = (e) ->
  e.preventDefault()

  session = it61.editor
  md = marked session.getValue()
  $('#preview .md_preview').html md
  $('.nav-tabs li.preview a').tab 'show'

@Styx.Initializers.Events =
  edit: ->
    $ ->
      initMarked()
      initAce $('#event_description')
      bindPreview()
      bindEdit()
