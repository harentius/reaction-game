((global) ->
  'use strict'

  class LevelManager
    constructor: () ->
      @.config = app.config.game
      @.stateManager = new app.StateManager()

    create: (levelNumber, width, height) ->
      levelConfig = @.config.levels[levelNumber]
      throw "Config for level #{levelNumber} not found" if !levelConfig
      level = new app.Level()
      numbers = @.config.levels[levelNumber].numbers
      nX = @._calculateNX(width, height, numbers)
      nY = @._calculateNY(width, height, numbers)
      level.state = @.stateManager.create(levelConfig, nX, nY)
      level.timeToSolve = levelConfig.timeToSolve
      level.number = levelNumber
      level.nX = nX
      level.nY = nY

      level

    _calculateNX: (width, height, numbers) ->
      @._optimizeN(width * numbers / height)

    _calculateNY: (width, height, numbers) ->
      @._optimizeN(height * numbers / width)

    _optimizeN: (rawResult) ->
      exactNumber = Math.sqrt(rawResult)
      numberForDisplaying = Math.ceil(exactNumber)

      if numberForDisplaying == exactNumber
        numberForDisplaying++

      numberForDisplaying

  global.app ||= {}
  global.app.LevelManager = LevelManager
)(window)
