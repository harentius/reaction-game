((global) ->
  'use strict'

  class Level
    constructor: () ->
      @.state = null
      @.timeToSolve = null


  global.Reaction ||= {}
  global.Reaction.Level = Level
)(window)
