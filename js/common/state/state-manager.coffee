((global) ->
  'use strict'

  class StateManager
    constructor: () ->
      @.config = Reaction.config

    create: (config, nX, nY) ->
      state = new Reaction.State( @.config.minAvailableNumbers)
      numberManager = new Reaction.NumberManager(state)
      positions = []

      for x in [0...nX]
        for y in [0...nY]
          positions.push([y, x])

      for [1..config.numbers]
        i = Reaction.generateNumber(0, positions.length)
        numberManager.generateRandomNumberAtXY(positions[i][0], positions[i][1])
        positions.splice(i, 1)

      state

  global.Reaction ||= {}
  global.Reaction.StateManager = StateManager
)(window)
