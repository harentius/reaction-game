((global) ->
  'use strict'

  class State
    data: []
    availablePlaces: []
    availableNumbers: []
    availabilityAreaDistance: 0
    minAvailableNumbers: 0
    maxNumberWasAvailable: 0

    constructor: (availabilityAreaDistance = 0, minAvailableNumbers = 5) ->
      @.availabilityAreaDistance = availabilityAreaDistance
      @.minAvailableNumbers = minAvailableNumbers
      @.availableNumbers.push(i) for i in [1...minAvailableNumbers]
      @.maxNumberWasAvailable = minAvailableNumbers

    getData: () ->
      @.data

    getAvailableNumbers: () ->
      @.availableNumbers

    getAvailablePlaces: () ->
      @.availablePlaces

    setXY: (x, y, value) ->
      @.data.push([x, y, value])
      @.updateAvailablePlaces(x, y)
      @.updateAvailableNumbers(value)

    getXY: (x, y, def = null) ->
      index = @.getIndexOfAvailable(x, y)

      return if index then @.data[index] else def

    getIndexOfAvailable: (x, y) ->
      for val, i in @.availablePlaces
        return i if val[0] == x and val[1] == y

      null

    isEmpty: (x, y) ->
      @.getIndexOfAvailable(x, y) == null

    updateAvailableNumbers: (value) ->
      index = @.availableNumbers.indexOf(value)
      @.availableNumbers.splice(index, 1) if index != -1
      newMaxNumber = @.maxNumberWasAvailable + @.minAvailableNumbers - @.availableNumbers.length

      return if newMaxNumber == @.maxNumberWasAvailable

      for i in [@.maxNumberWasAvailable...newMaxNumber]
        @.availableNumbers.push(i)

      @.maxNumberWasAvailable = newMaxNumber

    updateAvailablePlaces: (x, y) ->
      # Remove element from available list
      index = @.getIndexOfAvailable(x, y)

      @.availablePlaces.splice(index, 1) if index != null

      # Update available places
      for i in [(x - @.availabilityAreaDistance)..(x + @.availabilityAreaDistance)]
        for j in [(y - @.availabilityAreaDistance)..(y + @.availabilityAreaDistance)]
          index = @.getIndexOfAvailable(i, j)

          if index == null and @.isEmpty(i, j)
            @.availablePlaces.push([i, j])

  global.Reaction ||= {}
  global.Reaction.State = State
)(window)
