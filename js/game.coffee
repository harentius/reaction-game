((global) ->
  'use strict'

  class Game
    GAME_STARTED: 'game_started'
    GAME_OVER: 'game_over'
    LEFT_TIME_CHANGED: 'left_time_changed'
    SCORE_CHANGED: 'score_changed'

    constructor: ($container, width, height) ->
      @.$container = $container
      @.width = width
      @.height = height
      @.config = Reaction.config
      @.timeLeft = null
      @.score = null
      @.generatorInterval = null
      @.deadlineInterval = null
      @.events = []
      @.state = null

    start: () ->
      return if @.generatorInterval
      @.state = new Reaction.State(@.config.availabilityAreaDistance, @.config.minAvailableNumbers)
      stateManager = new Reaction.StateManager(@.state)
      dataRenderer = new Reaction.DataRenderer(@.$container, @.width, @.height)

      @.generatorInterval = Reaction.immediateInterval(() =>
        stateManager.tick()
        dataRenderer.render(@.state)
        @.timeLeft = @.config.selectionDeadline + @.config.selectionDeadlineUpdateInterval
      , @.config.gameTickInterval)

      @.deadlineInterval = Reaction.immediateInterval(() =>
        @.timeLeft = Math.max(@.timeLeft - @.config.selectionDeadlineUpdateInterval, 0)
        @.trigger(@.LEFT_TIME_CHANGED)

        if @.timeLeft <= 0
          @.stop()
      , @.config.selectionDeadlineUpdateInterval)

      @.score = 0
      @.trigger(@.SCORE_CHANGED)
      @.trigger(@.GAME_STARTED)

    stop: () ->
      clearInterval(@.generatorInterval)
      clearInterval(@.deadlineInterval)
      @.generatorInterval = null
      @.trigger(@.GAME_OVER)

    choose: (x, y) ->
      if (@.state.getXY(x, y) == @.state.getMax())
        @.score += 100
      @.trigger(@.SCORE_CHANGED)

    on: (event, callback) ->
      @.events.push({
        'event': event
        'callback': callback
      })

    trigger: (event) ->
      for e in @.events
        if e.event == event
          e.callback.call(@)

    getHumanizedTimeLeft: () ->
      ~~@.timeLeft / @.config.selectionDeadlineUpdateInterval

    getScore: () ->
      @.score


  global.Reaction ||= {}
  global.Reaction.Game = Game
)(window)
