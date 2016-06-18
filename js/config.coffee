((global) ->
  'use strict'

  global.Reaction ||= {}
  global.Reaction.config =
    availabilityAreaDistance: 1
    minAvailableNumbers: 5
    minAvailablePlaces: 5
    gameTickInterval: 2000
    selectionDeadline: 5000
    selectionDeadlineUpdateInterval: 1000
    newNumbersOnTick: 2
)(window)
