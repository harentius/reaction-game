((global) ->
  'use strict'

  global.app ||= {}
  global.app.immediateInterval = (callback, interval) ->
    callback()
    setInterval(() ->
      callback()
    , interval)

  global.app.generateNumber = (min, max) ->
    Math.floor(Math.random() * (max - min)) + min

  global.app.refreshMenu = () ->
    $('#stop-game').hide()
    $('#new-game').show()

  global.isTouchScreen = false
  $(document).one('touchstart', () ->
    global.isTouchScreen = true
  )
)(window)
