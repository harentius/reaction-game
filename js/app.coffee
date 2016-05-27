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
      $('#time-left').text(@.getTimeLeftInSeconds())
    )

    game.on(game.SCORE_CHANGED, () ->
      $('#score').text(@.getScore())
    )

    game.on(game.CHOOSE_RIGHT, (data) ->
      game.renderXY(data[0], data[1])
    )

    game.on(game.CHOOSE_WRONG, (data) ->
      game.renderXY(data[0], data[1])
    )

    $('#new-game').on('click', () ->
      game.start()
      $('.info-wrapper').show()
    )

    $('#stop-game').on('click', () ->
      game.stop()
    )

    $(document).on('click', '.cell.filled', (e) ->
      $cell = $(e.target).closest('.cell')
      game.choose(
        ~~$cell.closest('.row').data('row'),
        ~~$cell.data('col')
      )
    )
  )
)(window, jQuery)
