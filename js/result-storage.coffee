((global, $) ->
  'use strict'

  global.app ||= {}

  class ResultStorage
    constructor: () ->
      @.isFirebaseInitialized = false
      @.config = global.app.config

    save: (userName, score) ->
      @._initialize()
      ref = global.firebase.database()
        .ref("scores-v2/#{userName}")

      ref
        .once('value', (snap) =>
          if snap.exists() and snap.val() > score
            return

          ref.set(score)
        )

    getRelevantResults: (score, userName, limit = 12) ->
      @._initialize()
      highestLimit = 5
      partSize = ~~((limit - highestLimit) / 2)
      scoresDB = global.firebase.database().ref('scores-v2')

      highestScoresDfd = $.Deferred()
      scoresDB
        .orderByValue()
        .limitToLast(highestLimit)
        .once('value', (snap) =>
          highestScoresDfd.resolve(@._retrieveData(snap).reverse())
        )

      higherScoresDfd = $.Deferred()
      scoresDB
        .startAt(score)
        .orderByValue()
        .limitToFirst(partSize)
        .once('value', (snap) =>
          higherScoresDfd.resolve(@._retrieveData(snap).reverse())
        )

      lowerScoresDfd = $.Deferred()
      scoresDB
        .endAt(score)
        .orderByValue()
        .limitToLast(limit - highestLimit - partSize)
        .once('value', (snap) =>
          lowerScoresDfd.resolve(@._retrieveData(snap).reverse())
        )

      higherScoresCountDfd = $.Deferred()
      scoresDB
        .startAt(score)
        .orderByValue()
        .once('value', (snap) ->
          higherScoresCountDfd.resolve(snap.numChildren())
        )

      dfd = $.Deferred()
      $.when(highestScoresDfd, higherScoresDfd, lowerScoresDfd, higherScoresCountDfd)
        .done((highestScores, higherScores, lowerScores, higherScoresCount) ->
          rating = []
          ratingMap = {}
          position = 1
          shouldInsertNotSavedResult = false
          prevScore = null

          for chunk, i in [highestScores, higherScores, lowerScores]
            for result, j in chunk
              if ratingMap[result.userName]
                continue

              if result.userName == userName and score < result.score
                shouldInsertNotSavedResult = true

              if shouldInsertNotSavedResult and prevScore > score and score >= result.score
                rating.push({
                  position: position
                  userName: userName
                  score: score
                })
                position++
                shouldInsertNotSavedResult = false

              result.position = position

              if i == 0 && j == chunk.length - 1
                position += higherScoresCount

              rating.push(result)
              position++

              ratingMap[result.userName] = true
              prevScore = result.score

          if shouldInsertNotSavedResult
            rating.push({
              position: position
              userName: userName
              score: score
            })

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
        key = childSnapshot.key
        val = childSnapshot.val()
        data.push({
          userName: key
          score: val
        })

        false
      )

      data

  global.app.ResultStorage = new ResultStorage()
)(window, jQuery)
