((global) ->
  'use strict'

  class Level
    constructor: () ->
      @.state = null
      @.timeToSolve = null
      @.number = null
      @.nX = null
      @.nY = null


  global.Reaction ||= {}
  global.Reaction.Level = Level
)(window)
