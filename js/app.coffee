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
    )

    $('#stop-game').on('click', () ->
      game.stop()
    )

    game
      .on(game.LEFT_TIME_CHANGED, () ->
        $('#time-left').text(@.getTimeLeftInSeconds())
      ).on(game.SCORE_CHANGED, () ->
        $('#score').text(@.getScore())
      ).on(game.CHOOSE_RIGHT, (data) ->
        game.renderXY(data[0], data[1])
      ).on(game.CHOOSE_WRONG, (data) ->
        game.renderXY(data[0], data[1])
      ).on(game.GAME_OVER, () ->
        $(document).off('click')
        $('#game-over-dialog').modal()
      ).on(game.GAME_STARTED, () ->
        $('.info-wrapper').show()
        $(document).on('click', '.cell.filled', (e) ->
          $cell = $(e.target).closest('.cell')
          game.choose(
            ~~$cell.closest('.row').data('row'),
            ~~$cell.data('col')
          )
        )
    )
  )
)(window, jQuery)
