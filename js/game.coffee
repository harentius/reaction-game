((global) ->
  'use strict'

  class Game
    GAME_STARTED: 'game_started'
    GAME_OVER: 'game_over'
    LEFT_TIME_CHANGED: 'left_time_changed'
    SCORE_CHANGED: 'score_changed'
    CHOOSE_RIGHT: 'choose_right'
    CHOOSE_WRONG: 'choose_wrong'

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
      @.dataRenderer = null

    start: () ->
      return if @.generatorInterval
      @.state = new Reaction.State(@.config.availabilityAreaDistance, @.config.minAvailableNumbers)
      stateManager = new Reaction.StateManager(@.state)
      @.dataRenderer = new Reaction.DataRenderer(@.$container, @.width, @.height)
      @.refreshTimeLeft()

      @.generatorInterval = Reaction.immediateInterval(() =>
        stateManager.tick()
        @.dataRenderer.render(@.state)
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

    refreshTimeLeft: () ->
      @.timeLeft = @.config.selectionDeadline + @.config.selectionDeadlineUpdateInterval
      @.trigger(@.LEFT_TIME_CHANGED)

    renderXY: (x, y) ->
      @.dataRenderer.renderXY(x, y, @.state)

    renderGrid: () ->
      @.dataRenderer.render(@.state)

    choose: (x, y) ->
      max = @.state.getMax()

      if (@.state.getXY(x, y) == max)
        @.score += ~~(4 + 3 * Math.log(max) + 2.5 * @.getTimeLeftInSeconds())
        @.state.removeXY(x, y)
        @.refreshTimeLeft()
        @.trigger(@.CHOOSE_RIGHT, [x, y])
      else
        @.trigger(@.CHOOSE_WRONG, [x, y])

      @.trigger(@.SCORE_CHANGED)

    on: (event, callback) ->
      @.events.push({
        'event': event
        'callback': callback
      })

    trigger: (event, data = []) ->
      for e in @.events
        if e.event == event
          e.callback.call(@, data)

    getTimeLeftInSeconds: () ->
      ~~@.timeLeft / @.config.selectionDeadlineUpdateInterval

    getScore: () ->
      @.score


  global.Reaction ||= {}
  global.Reaction.Game = Game
)(window)
