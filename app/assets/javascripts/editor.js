//= require ace/ace
//= require ace/theme-github
//= require ace/mode-markdown
//= require marked

marked.setOptions
  gfm: true
  tables: true
  breaks: true
  pedantic: true
  sanitize: true
  smartLists: false
  smartypants: false
