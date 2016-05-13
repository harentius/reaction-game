((global, $) ->
  'use strict'

  class Grid
    bounds:
      minI: null
      maxI: null
      minJ: null
      maxJ: null

    $container: null

    constructor: (bounds, width, height, $container) ->
      @.bounds = bounds
      @.$container = $container
      cellSize = @._calculateCellSize(bounds, width, height)

      @.init(bounds, cellSize, $container)

    init: (bounds, cellSize, $container) ->
      content = ''
      sizeString = "#{cellSize}px"
      rowAttributes =
        'class': 'row'
        'data-row': null
      colAttributes =
        'class': 'coll cell'
        'style': @._compileAttributes(
          'width': sizeString
          'height': sizeString
          'line-height': sizeString
          'font-size': "#{cellSize / 2}px"
        , (n, v) -> "#{n}: #{v};")
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

    _compileAttributes: (object, formatter = (n, v) -> "#{n}=\"#{v}\"") ->
      attrs = []

      for attr, value of object
        attrs.push(formatter(attr, value))

      attrs.join(' ')

    _calculateCellSize: (bounds, gridWidth, gridHeight) ->
      elementsI = Math.abs(bounds.maxI - bounds.minI) + 1
      elementsJ = Math.abs(bounds.maxJ - bounds.minJ) + 1
      # Also accounts margins
      cellSizeI = gridHeight / elementsI - 2 * elementsI
      cellSizeJ = gridWidth / elementsJ - 2 * elementsJ

      if cellSizeI < cellSizeJ
        return ~~cellSizeI
      else
        return ~~cellSizeJ

  global.Reaction ||= {}
  global.Reaction.Grid = Grid
)(window, jQuery)
