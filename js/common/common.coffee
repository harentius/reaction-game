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

  global.isTouchScreen = false
  $(document).one('touchstart', () ->
    global.isTouchScreen = true
  )
)(window)
