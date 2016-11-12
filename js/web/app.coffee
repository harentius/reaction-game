((global, $) ->
  'use strict'

  global.app.share = null

  global.app.onHighScoresShow = (shareText) ->
    global.app.share = Ya.share2('share',
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

  $(() ->
    game = app.createGame()

    game
      .on(game.GAME_START, () ->
        global.app.share.destroy() if global.app.share != null
      )


    global.app.game = game
  )
)(window, jQuery)
