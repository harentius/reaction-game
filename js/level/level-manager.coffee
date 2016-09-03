((global) ->
  'use strict'

  class LevelManager
    constructor: () ->
      @.config = Reaction.config
      @.stateManager = new Reaction.StateManager()

    create: (levelNumber, width, height) ->
      levelConfig = @.config.levels[levelNumber]
      throw "Config for level #{levelNumber} not found" if !levelConfig
      level = new Reaction.Level()
      numbers = @.config.levels[levelNumber].numbers
      level.state = @.stateManager.create(
        levelConfig,
        @._calculateNX(width, height, numbers)
        @._calculateNY(width, height, numbers)
      )
      level.timeToSolve = levelConfig.timeToSolve
      level.number = levelNumber

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

  global.Reaction ||= {}
  global.Reaction.LevelManager = LevelManager
)(window)
