init = ->
  $('.bs-tooltip-icon').tooltip()

@Styx.Initializers.UserProfiles =
  new: ->
    $ ->
      init()
  edit: ->
    $ ->
      init()
  update: ->
    $ ->
      init()