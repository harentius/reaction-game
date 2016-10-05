((global) ->
  'use strict'

  class DataRenderer
    constructor: ($container, $transitionScreen, width, height) ->
      @.$container = $container
      @.$transitionScreen = $transitionScreen
      @.width = width
      @.height = height
      @.grid = null

    renderXY: (x, y, level) ->
      val = level.state.getXY(x, y)
      @._createGridIfNotExists(level)
      @.grid.set(x, y, if val then val else ' ')

    render: (level) ->
      @._createGridIfNotExists(level)
      data = level.state.getData()

      return if !data

      for val in data
        @.grid.set(val[0], val[1], if val[2] then val[2] else ' ')

    clearGrid: () ->
      @.grid = null

    renderTransition: (text, showingTime = 1500) ->
      deferred = new $.Deferred()
      containerPosition = @.$container.position()

      @.$transitionScreen.show()
      @.$transitionScreen.css({
        width: @.$container.width()
        height: @.$container.height()
        top: containerPosition.top
        left: containerPosition.left
      })
      @.$transitionScreen.text(text)
      setTimeout(() =>
        @.$transitionScreen.hide()
        deferred.resolve()
      , showingTime)

      return deferred

    getWidth: () -> @.width

    getHeight: () -> @.height

    setSize: (width, height) ->
      @.width = width
      @.height = height
      @.clearGrid()

    _createGridIfNotExists: (level) ->
      return if @.grid

      @.grid = new app.Grid(@.width, @.height, level.nX, level.nY, level.state.getData(), @.$container)

  global.app ||= {}
  global.app.DataRenderer = DataRenderer
)(window)
