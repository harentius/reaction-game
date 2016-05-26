((global, $) ->
  'use strict'

  $(() ->
    $container = $('.container')
    game = new Reaction.Game(
      $('#reaction-grid'),
      $container.width(),
      $container.height() - $('.nav-wrapper').height()
    )

    $('#new-game').on('click', () ->
      game.start()
      $('.info-wrapper').show()
    )

    $('#stop-game').on('click', () ->
      game.stop()
    )
  )
)(window, jQuery)
