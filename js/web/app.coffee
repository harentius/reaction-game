((global, $) ->
  'use strict'

  $(() ->
    game = app.createGame()
    share = null

    showSocialDialog = (title, shareText) ->
      $('.game-over-content').show()
      $('.highscores-content').hide()
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
      app.refreshMenu()
      $('#game-over-dialog').modal()

    game
      .on(game.GAME_OVER, () ->
        showSocialDialog('Game Over', "I reached score #{game.getScore()} in Sequence Master Game!")
      ).on(game.GAME_WIN, () ->
        showSocialDialog('Congratulations! You won!',"I won Sequence Master Game with score #{game.getScore()}!")
      ).on(game.GAME_START, () ->
        share.destroy() if share != null
      )


    global.app.game = game
  )
)(window, jQuery)
