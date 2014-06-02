init = ->
  initMarked()
  bindPreview()

initMarked = ->
  marked.setOptions
    gfm: true
    tables: true
    pedantic: false
    sanitize: false
    smartLists: true
    smartypants: false

bindPreview = ->
  $('ul.event-description li.preview').click (e) ->
    previewTabHandler e

previewTabHandler = (e) ->
  e.preventDefault()
  e.stopPropagation()

  session = $('.ace_editor').aced().getSession()
  md = marked session.getValue()
  $('#preview .md_preview').html md

  $('.nav-tabs li.preview a').tab 'show'
  false

$ ->
  # FIXME: Подключить styx и выполнять инициализацию только там, где предполагается наличие редактора
  init()