((global) ->
  'use strict'

  global.Reaction ||= {}

  global.Reaction.config =
    availabilityAreaDistance: 1
    minAvailableNumbers: 5
    gameTickInterval: 1000
    selectionInterval: 5000
)(window)
