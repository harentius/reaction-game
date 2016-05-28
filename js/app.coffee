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
      ).on(game.GAME_STARTED, () ->
        $('.info-wrapper').show()
        $(document).on('click', '.cell.filled', (e) ->
          $cell = $(e.target).closest('.cell')
          game.choose(
            ~~$cell.closest('.row').data('row'),
            ~~$cell.data('col')
          )
        )
      ).on(game.GAME_OVER, () ->
        shareText =  "I reached score #{game.getScore()} in Reaction Game!"
        $(document)
        .off('click')
        .prop('title', shareText)

        Ya.share2('share',
          theme:
            services: 'facebook,twitter,vkontakte,gplus'
            counter: true
            lang: 'uk'
            size: 'm'
          content:
            title: shareText
            description: shareText
        )

        $('#result-score').text(game.getScore())
        $('#game-over-dialog').modal()
      )
  )
)(window, jQuery)
