((global, $) ->
  'use strict'

  global.app ||= {}

  class ResultStorage
    constructor: () ->
      @.isFirebaseInitialized = false
      @.config = global.app.config

    save: (userName, score) ->
      @._initialize()
      scoresDB = global.firebase.database().ref('scores')
      scoresDB.push({
        score: score
        userName: userName
      })

    getRelevantResults: (score, limit = 12) ->
      @._initialize()
      highestLimit = 5
      partSize = ~~((limit - highestLimit) / 2)
      scoresDB = global.firebase.database().ref('scores')

      highestScoresDfd = $.Deferred()
      scoresDB
        .orderByChild('score')
        .limitToLast(highestLimit)
        .once('value', (snap) =>
          highestScoresDfd.resolve(@._retrieveData(snap).reverse())
        )

      higherScoresDfd = $.Deferred()
      scoresDB
        .startAt(score)
        .orderByChild('score')
        .limitToFirst(partSize)
        .once('value', (snap) =>
          higherScoresDfd.resolve(@._retrieveData(snap).reverse())
        )

      lowerScoresDfd = $.Deferred()
      scoresDB
        .endAt(score)
        .orderByChild('score')
        .limitToLast(limit - highestLimit - partSize)
        .once('value', (snap) =>
          lowerScoresDfd.resolve(@._retrieveData(snap).reverse())
        )

      # Workaround getting number of higher results (Performance sucks. Should reimplement this if at least 100-1000 people will play this shit)
      higherScoresCountDfd = $.Deferred()
      scoresDB
        .startAt(score)
        .orderByChild('score')
        .once('value', (snap) ->
          higherScoresCountDfd.resolve(Object.keys(snap.val()).length)
        )

      dfd = $.Deferred()
      $.when(highestScoresDfd, higherScoresDfd, lowerScoresDfd, higherScoresCountDfd)
        .done((highestScores, higherScores, lowerScores, higherScoresCount) ->
          rating = []
          ratingMap = {}
          position = 1

          for chunk, i in [highestScores, higherScores, lowerScores]
            for score, j in chunk
              mapKey = score.userName + score.score
              score.position = position

              if i == 0 && j == chunk.length - 1
                position += higherScoresCount

              if !ratingMap[mapKey]
                rating.push(score)
                position++

              ratingMap[mapKey] = true

          dfd.resolve(rating)
        )

      dfd.promise()

    _initialize: () ->
      return if @.isFirebaseInitialized
      global.firebase.initializeApp(@.config.firebase)
      @.isFirebaseInitialized = true

    _retrieveData: (snap) ->
      data = []
      snap.forEach((childSnapshot) ->
        data.push(childSnapshot.val())

        false
      )

      data

  global.app.ResultStorage = new ResultStorage()
)(window, jQuery)
