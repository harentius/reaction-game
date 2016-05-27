((global) ->
  'use strict'

  class DataRenderer
    constructor: ($container, width, height) ->
      @.$container = $container
      @.width = width
      @.height = height
      @.grid = null

    renderXY: (x, y, state) ->
      val = state.getXY(x, y)
      @.grid.set(x, y, if val then val else ' ')

    render: (state) ->
      data = state.getData()

      return if !data

      bounds = @._getBounds(data)

      if @._hasToInitGrid(bounds)
        @.grid = new Reaction.Grid(bounds, @.width, @.height, @.$container)

      for val in data
        @.grid.set(val[0], val[1], if val[2] then val[2] else ' ')

    _hasToInitGrid: (bounds) ->
      return true if not @.grid

      gridBounds = @.grid.getBounds()

      return (gridBounds.minI != bounds.minI || gridBounds.maxI != bounds.maxI ||
        gridBounds.minJ != bounds.minJ || gridBounds.maxJ != bounds.maxJ
      )

    _getBounds: (data) ->
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


  global.Reaction ||= {}
  global.Reaction.DataRenderer = DataRenderer
)(window)
