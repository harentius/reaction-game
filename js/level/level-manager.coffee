((global) ->
  'use strict'

  class LevelManager
    constructor: () ->
      @.config = Reaction.config
      @.stateManager = new Reaction.StateManager()

    create: (levelNumber) ->
      levelConfig = @.config.levels[levelNumber]
      throw "Config for level #{levelNumber} not found" if !levelConfig
      level = new Reaction.Level()
      level.state = @.stateManager.create(levelConfig)
      level.timeToSolve = levelConfig.timeToSolve

      level

  global.Reaction ||= {}
  global.Reaction.LevelManager = LevelManager
)(window)
