((global) ->
  'use strict'

  class Game
    constructor: ($container, width, height) ->
      @.$container = $container
      @.width = width
      @.height = height
      @.config = Reaction.config
      @.generatorInterval = null

    start: () ->
      return if @.generatorInterval
      state = new Reaction.State(@.config.availabilityAreaDistance, @.config.minAvailableNumbers)
      stateManager = new Reaction.StateManager(state)
      dataRenderer = new Reaction.DataRenderer(@.$container, @.width, @.height)

      mainLoop = () ->
        stateManager.tick()
        dataRenderer.render(state)

      mainLoop()

      @.generatorInterval = setInterval(() ->
        mainLoop()
      , @.config.gameTickInterval)

    stop: () ->
      clearInterval(@.generatorInterval)
      @.generatorInterval = null


  global.Reaction ||= {}
  global.Reaction.Game = Game
)(window)
