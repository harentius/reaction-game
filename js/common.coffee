((global) ->
  'use strict'

  global.Reaction ||= {}
  global.Reaction.immediateInterval = (callback, interval) ->
    callback()
    setInterval(() ->
      callback()
    , interval)
)(window)
