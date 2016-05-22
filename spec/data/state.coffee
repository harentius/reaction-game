sort = (array) ->
  return array if array.length < 1

  length = array[0].length

  for i in [0..length]
    array.sort((a, b) ->
      return 1 if a[i] > b[i]
      return -1 if a[i] < b[i]
      return 0 if a[i] = b[i]
    )

  array

equalArrays = (arr1, arr2) ->
  return true if (arr1 == arr2)
  return false if (arr1 == null || arr2 == null)
  arr1.sort()
  arr2.sort()

  for e, k in arr1
    return false if e != arr2[k]

  return true

equalArrays2Dim = (arr1, arr2) ->
  return true if (arr1 == arr2)
  return false if (arr1 == null || arr2 == null)
  return false if (arr1.length != arr2.length)

  arr1 = sort(arr1)
  arr2 = sort(arr2)

  for e, k in arr1
    return false if e[0] != arr2[k][0] || e[1] != arr2[k][1]

  return true


describe("Testing data/state ", () ->
  state = null
  config =
    availabilityAreaDistance: 1
    minAvailableNumbers: 5

  beforeEach(() ->
    state = new Reaction.State(config.availabilityAreaDistance, config.minAvailableNumbers)
  )

  it("Should correctly initialize available places after creating instance", () ->
    expectedPlaces = [
      [-1, -1]
      [-1, 0]
      [0, -1]
      [0, 0]
      [0, 1]
      [1, 0]
      [1, 1]
      [-1, 1]
      [1, -1]
    ]

    expect(equalArrays2Dim(state.getAvailablePlaces(), expectedPlaces)).toBe(true);
  )

  it("Should correctly initialize numbers after creating instance", () ->
    expectedNumbers = [1, 2, 3, 4, 5]

    expect(equalArrays(state.getAvailableNumbers(), expectedNumbers)).toBe(true);
  )
)
