((global) ->
  'use strict'

  class Game
    GAME_STARTED: 'game_started'
    NEW_NUMBERS_GENERATED: 'digits_generated'
    GAME_OVER: 'game_over'
    LEFT_TIME_CHANGED: 'left_time_changed'
    SCORE_CHANGED: 'score_changed'
    CHOOSE_RIGHT: 'choose_right'
    CHOOSE_WRONG: 'choose_wrong'
    LEVEL_START: 'level_start'
    LEVEL_WIN: 'level_win'
    LEVEL_LOST: 'level_lost'

    constructor: ($container, width, height) ->
      @.config = Reaction.config
      @.levelManager = new Reaction.LevelManager()
      @.dataRenderer = new Reaction.DataRenderer($container, width, height)
      @.timeLeft = null
      @.score = null
      @.timeLeftInterval = null
      @.events = []
      @.level = null
      @.active = false

    start: () ->
      @.score = 0
      @.active = true
      @.trigger(@.SCORE_CHANGED)
      @.trigger(@.GAME_STARTED)
      @._createLevel(1)

    stop: () ->
      return if !@.active
      clearInterval(@.timeLeftInterval)
      @.active = false
      @.trigger(@.GAME_OVER)

    refreshTimeLeft: () ->
      @.timeLeft = @.level.timeToSolve
      @.trigger(@.LEFT_TIME_CHANGED)

    renderXY: (x, y) ->
      @.dataRenderer.renderXY(x, y, @.level.state)

    renderGrid: () ->
      @.dataRenderer.render(@.level.state)

    choose: (x, y) ->
      max = @.level.state.getMax()

      if (@.level.state.getXY(x, y) == max)
        @.score += ~~(4 + 3 * Math.log(max) + 2.5 * @.getTimeLeftInSeconds())
        @.level.state.removeXY(x, y)
        @.level.state.setMinAvailableNumbers(@.level.state.getMinAvailableNumbers() + 1)
        @.trigger(@.CHOOSE_RIGHT, [x, y])
      else
        @.score = Math.max(@.score - 10, 0)
        @.trigger(@.CHOOSE_WRONG, [x, y])

      @.dataRenderer.render(@.level.state)
      @.trigger(@.SCORE_CHANGED)

    on: (event, callback) ->
      @.events.push({
        'event': event
        'callback': callback
      })

      this

    trigger: (event, data = []) ->
      for e in @.events
        if e.event == event
          e.callback.call(@, data)

    getTimeLeftInSeconds: () ->
      ~~@.timeLeft / @.config.selectionDeadlineUpdateInterval

    getScore: () ->
      @.score

    _createLevel: (levelNumber) ->
      @.level = @.levelManager.create(levelNumber)
      @.refreshTimeLeft()
      @.dataRenderer.render(@.level.state)
      data = @.level.state.getData()
      @.trigger(@.NEW_NUMBERS_GENERATED, data.slice(data.length - @.config.newNumbersOnTick))

      @.timeLeftInterval = Reaction.immediateInterval(() =>
        @.timeLeft = Math.max(@.timeLeft - @.config.selectionDeadlineUpdateInterval, 0)
        @.trigger(@.LEFT_TIME_CHANGED)

        if @.timeLeft <= 0
          @.stop()
      , @.config.selectionDeadlineUpdateInterval)

    _winLevel: () ->

    _lostLevel: () ->

  global.Reaction ||= {}
  global.Reaction.Game = Game
)(window)
