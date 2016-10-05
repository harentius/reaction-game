((global) ->
  'use strict'

  class StateManager
    constructor: () ->
      @.config = app.config

    create: (config, nX, nY) ->
      state = new app.State( @.config.minAvailableNumbers)
      numberManager = new app.NumberManager(state)
      positions = []

      for x in [0...nX]
        for y in [0...nY]
          positions.push([y, x])

      for [1..config.numbers]
        i = app.generateNumber(0, positions.length)
        numberManager.generateRandomNumberAtXY(positions[i][0], positions[i][1])
        positions.splice(i, 1)

      state

  global.app ||= {}
  global.app.StateManager = StateManager
)(window)
