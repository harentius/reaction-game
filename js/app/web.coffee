((global, $) ->
  'use strict'

  $(() ->
    calculateGameGridSize = () ->
      $container = $('.container')

      return {
        width: $container.width()
        height: $container.height() - $('.nav-wrapper').height()
      }

    gameGridSize = calculateGameGridSize()
    dataRenderer = new Reaction.DataRenderer(
      $('#reaction-grid'),
      $('#transition-screen'),
      gameGridSize.width,
      gameGridSize.height
    )
    game = new Reaction.Game(dataRenderer)
    share = null

    showSocialDialog = (title, shareText) ->
      $('#game-over-dialog').find('.title').text(title)
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
        $(".row[data-row='#{data[0]}'] .cell[data-col='#{data[1]}']").animo({ animation: 'right-selection', duration: 0.3}, () ->
          game.renderXY(data[0], data[1])
        )
      ).on(game.CHOOSE_WRONG, (data) ->
        $(".row[data-row='#{data[0]}'] .cell[data-col='#{data[1]}']").animo({ animation: 'wrong-selection', duration: 0.4})
      ).on(game.LEVEL_START, (data) ->
        $('#level').text(data[0] + 1)
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
        showSocialDialog('Game Over', "I reached score #{game.getScore()} in Reaction Game!")
      ).on(game.GAME_WIN, () ->
        showSocialDialog('Congratulations! You win!',"I wined Reaction Game with score #{game.getScore()}!")
      )

    $(global).on('resize', () ->
      gameGridSize = calculateGameGridSize()
      width = gameGridSize.width
      height = gameGridSize.height
      dataRenderer.setSize(width, height)
      game.setSize(width, height)
      game.render()
    )
  )
)(window, jQuery)
