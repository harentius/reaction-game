((global) ->
  'use strict'

  class StateManager
    constructor: (state) ->
      @.state = state
      @.generateRandomNumberAtXY(0, 0)

    tick: () ->
      @.generateRandomNumberAtRandomPosition() for i in [1..Reaction.config.newNumbersOnTick]

    generateRandomNumberAtRandomPosition: () ->
      availablePlaces = @.state.getAvailablePlaces()
      xy = availablePlaces[@.generateNumber(0, availablePlaces.length)]
      @.generateRandomNumberAtXY(xy[0], xy[1])

    generateRandomNumberAtXY: (x, y) ->
      availableNumbers = @.state.getAvailableNumbers()
      @.state.setXY(x, y, availableNumbers[@.generateNumber(0, availableNumbers.length)])

    generateNumber: (min, max) ->
      Math.floor(Math.random() * (max - min)) + min

    getData: () ->
      @.state.getData()

      
  global.Reaction ||= {}
  global.Reaction.StateManager = StateManager
)(window)
