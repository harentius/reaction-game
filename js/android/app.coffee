((global, $) ->
  'use strict'

  global.app.onHighScoresShow = (shareText) ->
    onSharingStop = () ->
      $('.navbar-collapse').collapse('hide')
      app.refreshMenu()

    $('.share-button').on('click', () ->
      plugins.socialsharing.shareWithOptions({
        message: shareText,
        url: 'https://rg.folkprog.net',
        chooserTitle: 'Share result'
      }, onSharingStop, onSharingStop)
    )

  $(() ->
    game = app.createGame()


    global.app.game = game
  )
)(window, jQuery)
