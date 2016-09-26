((global) ->
  'use strict'

  class NumberManager
    constructor: (state) ->
      @.state = state

    generateRandomNumberAtXY: (x, y) ->
      availableNumbers = @.state.getAvailableNumbers()
      @.state.setXY(x, y, availableNumbers[Reaction.generateNumber(0, availableNumbers.length - 1)])

    getData: () ->
      @.state.getData()

      
  global.Reaction ||= {}
  global.Reaction.NumberManager = NumberManager
)(window)
