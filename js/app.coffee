((global, $) ->
  'use strict'

  $(() ->
    $container = $('.container')
    game = new Reaction.Game(
      $('#reaction-grid'),
      $container.width(),
      $container.height() - $('.nav-wrapper').height()
    )

    game.on(game.LEFT_TIME_CHANGED, () ->
      $('#time-left').text(@.getHumanizedTimeLeft())
    )

    game.on(game.SCORE_CHANGED, () ->
      $('#score').text(@.getScore())
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
