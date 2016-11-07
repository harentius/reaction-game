((global, $) ->
  'use strict'

  $(() ->
    game = app.createGame()
    onSharingStop = () ->
      $('.navbar-collapse').collapse('hide')
      app.refreshMenu()

    proposeSharing = (title, shareText) ->
      plugins.socialsharing.shareWithOptions({
        message: shareText,
        url: 'https://rg.folkprog.net',
        chooserTitle: title
      }, onSharingStop, onSharingStop)

    game
      .on(game.GAME_OVER, () ->
        $('#game-over-dialog').modal()
        proposeSharing('Game Over', "I reached score #{game.getScore()} in Sequence Master Game!")
      ).on(game.GAME_WIN, () ->
        $('#game-over-dialog').modal()
        proposeSharing('Congratulations! You won!',"I won Sequence Master Game with score #{game.getScore()}!")
      )


    global.app.game = game
  )
)(window, jQuery)
