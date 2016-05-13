((global, $) ->
  'use strict'

  class Grid
    bounds:
      minI: null
      maxI: null
      minJ: null
      maxJ: null

    $container: null

    constructor: (bounds, $container) ->
      @.bounds = bounds
      @.$container = $container
      cellSize = @._calculateCellSize(bounds, $container)

      @.init(bounds, cellSize, $container)

    init: (bounds, cellSize, $container) ->
      content = ''

      for i in [bounds.minI..bounds.maxI]
        rowContent = ''

        for j in [bounds.minJ..bounds.maxJ]
          rowContent += "<div class=\"coll cell\" data-col=\"#{j}\" style=\"width: #{cellSize}px; height: #{cellSize}px;\"> </div>"

        content += "<div class=\"row\" data-row=\"#{i}\">#{rowContent}</div>"
      $container.html(content)

    set: (i, j, value) ->
      @.$container.find($("[data-row='#{i}'] [data-col='#{j}']")).text(value)

    getBounds: () -> @.bounds

    _calculateCellSize: (bounds, $container) ->
      elementsI = Math.abs(bounds.maxI - bounds.minI) + 1
      elementsJ = Math.abs(bounds.maxJ - bounds.minJ) + 1
      # Also accounts margins
      cellSizeI = $container.width() / elementsI - 2 * elementsI
      cellSizeJ = $container.height() / elementsJ - 2 * elementsJ

      if cellSizeI < cellSizeJ
        return cellSizeI
      else
        return cellSizeJ

  global.Reaction ||= {}
  global.Reaction.Grid = Grid
)(window, jQuery)
