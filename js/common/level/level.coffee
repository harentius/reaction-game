((global) ->
  'use strict'

  class Level
    constructor: () ->
      @.state = null
      @.timeToSolve = null
      @.number = null
      @.nX = null
      @.nY = null

  global.app ||= {}
  global.app.Level = Level
)(window)
