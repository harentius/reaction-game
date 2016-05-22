((global) ->
  'use strict'

  class State
    constructor: (availabilityAreaDistance = 1, minAvailableNumbers = 5) ->
      @.data = []
      @.availablePlaces = []
      @.availableNumbers = []
      @.availabilityAreaDistance = availabilityAreaDistance
      @.minAvailableNumbers = minAvailableNumbers
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
      index = @._getIndexOfAvailable(x, y)

      return if index then @.data[index] else def

    _getIndexOfAvailable: (x, y) ->
      for val, i in @.availablePlaces
        return i if val[0] == x and val[1] == y

      null

    _isEmpty: (x, y) ->
      @._getIndexOfAvailable(x, y) == null

    _updateAvailableNumbers: (value) ->
      index = @.availableNumbers.indexOf(value)
      @.availableNumbers.splice(index, 1) if index != -1
      newMaxNumber = @.maxNumberWasAvailable + @.minAvailableNumbers - @.availableNumbers.length

      return if newMaxNumber == @.maxNumberWasAvailable

      for i in [@.maxNumberWasAvailable...newMaxNumber]
        @.availableNumbers.push(i)

      @.maxNumberWasAvailable = newMaxNumber

    _updateAvailablePlaces: (x, y) ->
      # Remove element from available list
      index = @._getIndexOfAvailable(x, y)

      @.availablePlaces.splice(index, 1) if index != null

      # Update available places
      for i in [(x - @.availabilityAreaDistance)..(x + @.availabilityAreaDistance)]
        for j in [(y - @.availabilityAreaDistance)..(y + @.availabilityAreaDistance)]
          index = @._getIndexOfAvailable(i, j)

          if index == null and @._isEmpty(i, j)
            @.availablePlaces.push([i, j])

  global.Reaction ||= {}
  global.Reaction.State = State
)(window)
