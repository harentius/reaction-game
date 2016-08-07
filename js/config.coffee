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
    levels: [
      {
        timeToSolve: 5000
        numbers: 3
      },

      {
        timeToSolve: 8000
        numbers: 5,
      },

      {
        timeToSolve: 10000
        numbers: 10,
      },
    ]
)(window)
