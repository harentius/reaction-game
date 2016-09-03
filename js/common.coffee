((global) ->
  'use strict'

  global.Reaction ||= {}
  global.Reaction.immediateInterval = (callback, interval) ->
    callback()
    setInterval(() ->
      callback()
    , interval)

  global.Reaction.generateNumber = (min, max) ->
    Math.floor(Math.random() * (max - min)) + min
)(window)
