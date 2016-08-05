((global) ->
  'use strict'

  class StateManager
    constructor: () ->
      @.config = Reaction.config

    create: (config) ->
      state = new Reaction.State(@.config.availabilityAreaDistance, @.config.minAvailableNumbers, @.config.minAvailablePlaces)
      numberManager = new Reaction.NumberManager(state)
      numberManager.generateRandomNumberAtRandomPosition() for i in [1..config.numbers]

      state

  global.Reaction ||= {}
  global.Reaction.StateManager = StateManager
)(window)
