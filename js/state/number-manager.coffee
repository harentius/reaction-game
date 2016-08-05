((global) ->
  'use strict'

  class NumberManager
    constructor: (state) ->
      @.state = state
      @.generateRandomNumberAtXY(0, 0)

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
  global.Reaction.NumberManager = NumberManager
)(window)
