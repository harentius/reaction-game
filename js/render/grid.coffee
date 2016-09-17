((global, $) ->
  'use strict'

  class Grid
    constructor: (width, height, nX, nY, data, $container) ->
#      bounds: { minI: null, maxI: null, minJ: null, maxJ: null }
      @.bounds = @._getBounds(data)
      @.$container = $container
      cellSize = @._calculateCellSize(width, height, nX, nY)

      @.init(@.bounds, cellSize, $container)

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
      @.$container.css({
        # 2 is a margin
        width: sizeString + 2
      })

    set: (i, j, value) ->
      @.$container
        .find($("[data-row='#{i}'] [data-col='#{j}']"))
          .text(value)
          .removeClass('filled')
          .addClass(if value && value != ' ' then 'filled' else '')
        .end()

    _compileAttributes: (object, formatter = (n, v) -> "#{n}=\"#{v}\"") ->
      attrs = []

      for attr, value of object
        attrs.push(formatter(attr, value))

      attrs.join(' ')

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

    _calculateCellSize: (gridWidth, gridHeight, nX, nY) ->
      cellSizeI = gridHeight / nY
      cellSizeJ = gridWidth / nX

      # 2 - both side margins
      return ~~(if (cellSizeI < cellSizeJ) then cellSizeI else cellSizeJ) - 2

  global.Reaction ||= {}
  global.Reaction.Grid = Grid
)(window, jQuery)
