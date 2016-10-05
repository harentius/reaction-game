((global, $) ->
  'use strict'

  $(() ->
    gameGridSize = app.ui.calculateGameGridSize()
    dataRenderer = new app.DataRenderer(
      $('#reaction-grid'),
      $('#transition-screen'),
      gameGridSize.width,
      gameGridSize.height
    )
    game = new app.Game(dataRenderer)
    share = null

    showSocialDialog = (title, shareText) ->
      $('#game-over-dialog').find('.title').text(title)
      $(document).off('click', '.cell.filled')
      $(document).prop('title', shareText)

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
      $('.navbar-collapse').collapse('hide')
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
        $('.project-name').addClass('visibility-hidden') if $('.main-menu-toggler').is(':visible')
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
        showSocialDialog('Game Over', "I reached score #{game.getScore()} in Sequence Master Game!")
      ).on(game.GAME_WIN, () ->
        showSocialDialog('Congratulations! You won!',"I won Sequence Master Game with score #{game.getScore()}!")
      )


    global.app.game = game
    global.app.dataRenderer = dataRenderer
  )
)(window, jQuery)
