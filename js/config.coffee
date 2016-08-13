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
        timeToSolve: 6000
        numbers: 5
      },

      {
        timeToSolve: 10000
        numbers: 9
      },

      {
        timeToSolve: 15000
        numbers: 13
      },

      {
        timeToSolve: 21000
        numbers: 17
      },

      {
        timeToSolve: 33000
        numbers: 25
      },

      {
        timeToSolve: 55000
        numbers: 35
      },
    ]
)(window)
