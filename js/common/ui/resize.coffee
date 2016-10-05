((global, $) ->
  'use strict'

  $(() ->
    $(global).on('resize', () ->
      gameGridSize = app.ui.calculateGameGridSize()
      width = gameGridSize.width
      height = gameGridSize.height

      if not app.dataRenderer
        return

      app.dataRenderer.setSize(width, height)

      if not app.game || not app.game.level
        return

      app.game.setSize(width, height)
      app.game.render()
    )
  )
)(window, jQuery)
