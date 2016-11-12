((global, $) ->
  'use strict'

  global.app ||= {}

  global.app.createGame = () ->
    gameGridSize = app.ui.calculateGameGridSize()
    global.app.dataRenderer = new app.DataRenderer(
      $('#reaction-grid'),
      $('#transition-screen'),
      gameGridSize.width,
      gameGridSize.height
    )
    game = new app.Game(app.dataRenderer)
    app.registerGameCommonEventListeners(game)

    game

  global.app.registerGameCommonEventListeners = (game) ->
    $('#new-game').on('click', () ->
      $('.navbar-collapse').collapse('hide')
      game.start()
    )

    $('#stop-game').on('click', () ->
      game.stop()
    )

    showHighScoresTab = (rating, userName, score) ->
      $resultTable = $('.result-table')
      $resultTableBody = $resultTable.find('tbody')
      $resultTableBody.html('')
      rowTemplate = $resultTable.data('content-row-prototype')
      prevPosition = null

      for result in rating
        $row = $(rowTemplate)

        $row
          .find('.position').text(result.position).end()
          .find('.username').text(result.userName).end()
          .find('.score').text(result.score).end()

        if prevPosition and (result.position - prevPosition) != 1
          $resultTableBody.append($resultTable.data('missed-rows-prototype'))

        if result.userName == userName && result.score == score
          $row.addClass('success')

        prevPosition = result.position
        $resultTableBody.append($row)
        $('.game-over-content').hide()
        $('.highscores-content').show()

    $('.form-leaderboard-name').on('submit', (e) ->
      e.preventDefault()
      userName = $('.form-leaderboard-name').find('#name').val()
      score = game.getScore()
      app.ResultStorage.save(userName, score)
      app.ResultStorage.getRelevantResults(score)
        .done((rating) ->
          showHighScoresTab(rating, userName, score)
        )
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
      )
)(window, jQuery)
