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
      rowAttributes =
        'class': 'row'
        'data-row': null
      colAttributes =
        'class': 'coll cell'
        'style': "width: #{cellSize}px; height: #{cellSize}px;"
        'data-col': null

      for i in [bounds.minI..bounds.maxI]
        rowContent = ''

        for j in [bounds.minJ..bounds.maxJ]
          colAttributes['data-col'] = j
          attributes = @._compileAttributes(colAttributes)
          rowContent += "<div #{attributes}> </div>"

        rowAttributes['data-row'] = i
        attributes = @._compileAttributes(rowAttributes)
        content += "<div #{attributes}>#{rowContent}</div>"
      $container.html(content)

    set: (i, j, value) ->
      @.$container.find($("[data-row='#{i}'] [data-col='#{j}']")).text(value)

    getBounds: () -> @.bounds

    _compileAttributes: (object) ->
      attrs = ''

      for attr, value of object
        attrs += (if attrs then ' ' else '') + "#{attr}=\"#{value}\""

      attrs

    _calculateCellSize: (bounds, $container) ->
      elementsI = Math.abs(bounds.maxI - bounds.minI) + 1
      elementsJ = Math.abs(bounds.maxJ - bounds.minJ) + 1
      # Also accounts margins
      cellSizeI = $container.width() / elementsI - 2 * elementsI
      cellSizeJ = $container.height() / elementsJ - 2 * elementsJ

      if cellSizeI < cellSizeJ
        return ~~cellSizeI
      else
        return ~~cellSizeJ

  global.Reaction ||= {}
  global.Reaction.Grid = Grid
)(window, jQuery)
