((global) ->
  'use strict'

  class Game
    GAME_START: 'game_start'
    GAME_OVER: 'game_over'
    GAME_WIN: 'game_win'

    LEVEL_START: 'level_start'
    LEVEL_OVER: 'level_over'
    LEVEL_WIN: 'level_win'

    CHOOSE_RIGHT: 'choose_right'
    CHOOSE_WRONG: 'choose_wrong'

    LEFT_TIME_CHANGED: 'left_time_changed'
    SCORE_CHANGED: 'score_changed'

    constructor: (dataRenderer) ->
      @.dataRenderer = dataRenderer
      @.width = dataRenderer.getWidth()
      @.height = dataRenderer.getHeight()
      @.config = app.config.game
      @.levelManager = new app.LevelManager()
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
      @.trigger(@.GAME_START)
      @._createLevel(0)

    stop: () ->
      return if !@.active
      @.active = false
      @.trigger(@.GAME_OVER)
      @._overLevel()

    refreshTimeLeft: () ->
      @.timeLeft = @.level.timeToSolve
      @.trigger(@.LEFT_TIME_CHANGED)

    renderXY: (x, y) ->
      @.dataRenderer.renderXY(x, y, @.level)

    render: () ->
      @.dataRenderer.render(@.level)

    choose: (x, y) ->
      return if !@.active
      max = @.level.state.getMax()

      if (@.level.state.getXY(x, y) == max)
        @.score += ~~(4 + 3 * Math.log(max) + 2.5 * @.getTimeLeftInSeconds())
        @.level.state.removeXY(x, y)
        @.level.state.setMinAvailableNumbers(@.level.state.getMinAvailableNumbers() + 1)
        @.trigger(@.CHOOSE_RIGHT, [x, y])

        if @.level.state.data.length == 0
          @._winLevel()
      else
        @.score = Math.max(@.score - 10, 0)
        @.trigger(@.CHOOSE_WRONG, [x, y])

      @.renderXY(x, y)
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

    setSize: (width, height) ->
      @.width = width
      @.height = height

    _createLevel: (levelNumber) ->
      @.dataRenderer.clearGrid()
      @.level = @.levelManager.create(levelNumber, @.width, @.height)
      @.trigger(@.LEVEL_START, [levelNumber])
      @.refreshTimeLeft()
      @.dataRenderer.render(@.level)
      @.dataRenderer.renderTransition("Ready for Level #{levelNumber + 1}?")
        .done(() =>
          return if !@.active

          @.dataRenderer.renderTransition('Go!', 500)
            .done(() =>
              return if !@.active

              @.timeLeftInterval = app.immediateInterval(() =>
                @.timeLeft = Math.max(@.timeLeft - @.config.selectionDeadlineUpdateInterval, 0)
                @.trigger(@.LEFT_TIME_CHANGED)

                if @.timeLeft <= 0
                  @.stop()
              , @.config.selectionDeadlineUpdateInterval)
            )
        )

    _winLevel: () ->
      @._endLevel()
      @.trigger(@.LEVEL_WIN)
      nextLevelNumber = @.level.number + 1

      if nextLevelNumber < @.config.levels.length
        @._createLevel(nextLevelNumber)
      else
        @.trigger(@.GAME_WIN)

    _overLevel: () ->
      @._endLevel()
      @.trigger(@.LEVEL_OVER)

    _endLevel: () ->
      clearInterval(@.timeLeftInterval)


  global.app ||= {}
  global.app.Game = Game
)(window)
