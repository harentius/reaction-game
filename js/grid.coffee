((global, $) ->
  'use strict'

  class Grid
    bounds:
      minI: null
      maxI: null
      minJ: null
      maxJ: null

    $container: null
    cellWidth: null
    cellHeight: null

    constructor: (bounds, $container) ->
      @.bounds = bounds
      @.$container = $container

      # TODO: improve algorithm
      @.cellWidth = $container.width() / Math.abs((bounds.maxI - bounds.minI))
      @.cellHeight = @.cellWidth
      @.init(bounds, $container)

    init: (bounds, $container) ->
      content = ''
      # TODO
      for i in [bounds.minI..bounds.maxI]
        rowContent = ''

        for j in [bounds.minJ..bounds.maxJ]
          rowContent += "<div class=\"coll cell\" data-col=\"#{j}\" style=\"width: #{@.cellWidth}px; height: #{@.cellHeight}px;\"> </div>"

        content += "<div class=\"row\" data-row=\"#{i}\">#{rowContent}</div>"
      $container.html(content)

    set: (i, j, value) ->
      @.$container.find($("[data-row='#{i}'] [data-col='#{j}']")).text(value)

    getBounds: () -> @.bounds


  global.Reaction ||= {}
  global.Reaction.Grid = Grid
)(window, jQuery)
