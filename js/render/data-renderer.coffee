((global) ->
  'use strict'

  class DataRenderer
    constructor: ($container, $transitionScreen, width, height) ->
      @.$container = $container
      @.$transitionScreen = $transitionScreen
      @.width = width
      @.height = height
      @.grid = null

    renderXY: (x, y, state) ->
      val = state.getXY(x, y)
      @._createGridIfNotExists(state)
      @.grid.set(x, y, if val then val else ' ')

    render: (state) ->
      @._createGridIfNotExists(state)
      data = state.getData()

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

    _getBounds: (data) ->
      if data.length == 0
        return null

      bounds =
        minI: data[0][0]
        maxI: data[0][0]
        minJ: data[0][1]
        maxJ: data[0][1]

      for val in data
        bounds.minI = val[0] if val[0] < bounds.minI
        bounds.maxI = val[0] if val[0] > bounds.maxI
        bounds.minJ = val[1] if val[1] < bounds.minJ
        bounds.maxJ = val[1] if val[1] > bounds.maxJ

      return bounds

    _createGridIfNotExists: (state) ->
      return if @.grid

      @.grid = new Reaction.Grid(@._getBounds(state.getData()), @.width, @.height, @.$container)

  global.Reaction ||= {}
  global.Reaction.DataRenderer = DataRenderer
)(window)
