((global, $) ->
  'use strict'

  $(() ->
    $(global).on('resize', () ->
      gameGridSize = Reaction.ui.calculateGameGridSize()
      width = gameGridSize.width
      height = gameGridSize.height
      Reaction.dataRenderer.setSize(width, height)

      if not Reaction.app || not Reaction.app.active
        return

      Reaction.app.setSize(width, height)
      Reaction.app.render()
    )
  )
)(window, jQuery)
