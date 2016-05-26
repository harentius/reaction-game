((global) ->
  'use strict'

  class Game
    constructor: ($container, width, height) ->
      @.$container = $container
      @.width = width
      @.height = height
      @.interval = null

    start: () ->
      return if @.interval
      config = Reaction.config
      state = new Reaction.State(config.availabilityAreaDistance, config.minAvailableNumbers)
      stateManager = new Reaction.StateManager(state)
      dataRenderer = new Reaction.DataRenderer(@.$container, @.width, @.height)

      mainLoop = () ->
        stateManager.tick()
        dataRenderer.render(state)

      mainLoop()

      @.interval = setInterval(() ->
        mainLoop()
      , config.gameTickInterval)

    stop: () ->
      clearInterval(@.interval)
      @.interval = null
  global.Reaction ||= {}
  global.Reaction.Game = Game
)(window)