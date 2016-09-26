((global) ->
  'use strict'

  class State
    constructor: (minAvailableNumbers = 5) ->
      @.minAvailableNumbers = minAvailableNumbers
      @.data = []
      @.availableNumbers = []

      for i in [1..minAvailableNumbers]
        @.availableNumbers.push(i)

    getData: () ->
      @.data

    getAvailableNumbers: () ->
      @.availableNumbers

    setXY: (x, y, value) ->
      @.data.push([x, y, value])
      @._updateAvailableNumbers(value)

    getXY: (x, y, def = null) ->
      index = @._getIndex(x, y)

      return def if index == null
      return @.data[index][2]

    setMinAvailableNumbers: (value) ->
      @.minAvailableNumbers = value

    getMinAvailableNumbers: () ->
      @.minAvailableNumbers

    removeXY: (x, y) ->
      index = @._getIndex(x, y)

      if index != null
        value = @.getXY(x, y)
        @.data.splice(index, 1)
        @.availableNumbers.push(value)

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

    _getIndexByValue: (value) ->
      for v, i in @.data
        return i if v[2] == value

      null

    _updateAvailableNumbers: (value) ->
      index = @.availableNumbers.indexOf(value)
      @.availableNumbers.splice(index, 1) if index != -1

      while @.availableNumbers.length < @.minAvailableNumbers
        @.availableNumbers.push(@._generateAvailableNumber())

    _generateAvailableNumber: () ->
      maxMedian = ~~(Math.max.apply(Math, @.availableNumbers) / 2)
      isAvailableNumber = (i) =>
        @.availableNumbers.indexOf(i) == -1 and @._getIndexByValue(i) == null

      for i in [maxMedian..1]
        return i if isAvailableNumber(i)

      i = maxMedian + 1

      while true
        return i if isAvailableNumber(i)
        i++

  global.Reaction ||= {}
  global.Reaction.State = State
)(window)
