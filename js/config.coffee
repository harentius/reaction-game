((global) ->
  'use strict'

  global.Reaction ||= {}

  global.Reaction.config =
    availabilityAreaDistance: 1
    minAvailableNumbers: 5
    gameTickInterval: 400
    selectionInterval: 5000
)(window)
