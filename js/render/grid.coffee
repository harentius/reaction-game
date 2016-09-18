((global, $) ->
  'use strict'

  class Grid
    constructor: (width, height, nX, nY, data, $container) ->
      @.bounds = { minI: 0, maxI: nY - 1, minJ: 0, maxJ: nX - 1 }
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

    _calculateCellSize: (gridWidth, gridHeight, nX, nY) ->
      cellSizeI = gridHeight / nY
      cellSizeJ = gridWidth / nX

      # 2 - both side margins
      return ~~(if (cellSizeI < cellSizeJ) then cellSizeI else cellSizeJ) - 2

  global.Reaction ||= {}
  global.Reaction.Grid = Grid
)(window, jQuery)
