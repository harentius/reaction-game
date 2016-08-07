((global, $) ->
  'use strict'

  $(() ->
    $container = $('.container')
    share = null
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
        $score = $('#score')
        oldVal = $score.text()
        newVal = @.getScore()
        $score.text(newVal)

        if newVal > 0
          $score.animo({ animation: if newVal > oldVal then 'score-increased' else 'score-decreased' })
      ).on(game.CHOOSE_RIGHT, (data) ->
        $(".row[data-row='#{data[0]}'] .cell[data-col='#{data[1]}']").animo({ animation: 'right-selection', duration: 0.3 }, () ->
          game.renderXY(data[0], data[1])
        )
      ).on(game.CHOOSE_WRONG, (data) ->
        game.renderXY(data[0], data[1])
        $(".row[data-row='#{data[0]}'] .cell[data-col='#{data[1]}']").animo({ animation: 'wrong-selection' })
      ).on(game.GAME_START, () ->
        share.destroy() if share != null
        $('.info-wrapper').show()
        $(document).on('click', '.cell.filled', (e) ->
          $cell = $(e.target).closest('.cell')
          game.choose(
            ~~$cell.closest('.row').data('row'),
            ~~$cell.data('col')
          )
        )
        $('#stop-game').show()
        $('#new-game').hide()
      ).on(game.GAME_OVER, () ->
        shareText =  "I reached score #{game.getScore()} in Reaction Game!"
        $(document)
        .off('click')
        .prop('title', shareText)

        share = Ya.share2('share',
          theme:
            services: 'facebook,twitter,vkontakte,gplus'
            counter: true
            lang: 'uk'
            size: 'm'
          content:
            title: shareText
            description: shareText
            image: 'img/reaction-game.png'
        )

        $('#result-score').text(game.getScore())
        $('#stop-game').hide()
        $('#new-game').show()
        $('#game-over-dialog').modal()
      )
  )
)(window, jQuery)
