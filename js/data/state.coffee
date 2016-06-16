((global) ->
  'use strict'

  class State
    constructor: (availabilityAreaDistance = 1, minAvailableNumbers = 5, minAvailablePlaces = 5) ->
      @.data = []
      @.availablePlaces = []
      @.availableNumbers = []
      @.availabilityAreaDistance = availabilityAreaDistance
      @.minAvailableNumbers = minAvailableNumbers
      @.minAvailablePlaces = minAvailablePlaces
      @.maxNumberWasAvailable = minAvailableNumbers

      for i in [1..minAvailableNumbers]
        @.availableNumbers.push(i)

      for i in [-availabilityAreaDistance..availabilityAreaDistance]
        for j in [-availabilityAreaDistance..availabilityAreaDistance]
          @.availablePlaces.push([i, j])

    getData: () ->
      @.data

    getAvailableNumbers: () ->
      @.availableNumbers

    getAvailablePlaces: () ->
      @.availablePlaces

    setXY: (x, y, value) ->
      @.data.push([x, y, value])
      @._updateAvailablePlaces(x, y)
      @._updateAvailableNumbers(value)

    getXY: (x, y, def = null) ->
      index = @._getIndex(x, y)

      return def if index == null
      return @.data[index][2]

    removeXY: (x, y) ->
      index = @._getIndex(x, y)

      if index != null
        val = @.getXY(x, y)
        @.data.splice(index, 1)
        @.availablePlaces.push([x, y])

    getMax: () ->
      return null if @.data.length < 1

      max = @.data[0][2]

      for v in @.data
        max = v[2] if max < v[2]

      max

    _getIndex: (x, y) ->
      for v, i in @.data
        return i if v[0] == x and v[1] == y

      null

    _getIndexOfAvailable: (x, y) ->
      for v, i in @.availablePlaces
        return i if v[0] == x and v[1] == y

      null

    _isAvailable: (x, y) ->
      @._getIndex(x, y) == null and @._getIndexOfAvailable(x, y) == null

    _updateAvailableNumbers: (value) ->
      index = @.availableNumbers.indexOf(value)
      @.availableNumbers.splice(index, 1) if index != -1
      newMaxNumber = @.maxNumberWasAvailable + @.minAvailableNumbers - @.availableNumbers.length
      return if newMaxNumber < 0 ||  newMaxNumber == @.maxNumberWasAvailable

      for i in [@.maxNumberWasAvailable + 1..newMaxNumber]
        @.availableNumbers.push(i)

      @.maxNumberWasAvailable = newMaxNumber

    _updateAvailablePlaces: (x, y) ->
      # Remove element from available list
      index = @._getIndexOfAvailable(x, y)
      @.availablePlaces.splice(index, 1) if index != null

      return if @.availablePlaces.length > @.minAvailablePlaces
      # Update available places
      for i in [(x - @.availabilityAreaDistance)..(x + @.availabilityAreaDistance)]
        for j in [(y - @.availabilityAreaDistance)..(y + @.availabilityAreaDistance)]
          continue if i == x and j == y

          if @._isAvailable(i, j)
            @.availablePlaces.push([i, j])

  global.Reaction ||= {}
  global.Reaction.State = State
)(window)
