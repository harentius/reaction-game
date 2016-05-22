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

equalArrays2Dim = (places1, places2) ->
  return true if (places1 == places2)
  return false if (places1 == null || places2 == null)
  return false if (places1.length != places2.length)

  places1 = sort(places1)
  places2 = sort(places2)

  for e, k in places1
    return false if e[0] != places2[k][0] || e[1] != places2[k][1]

  return true


describe("Testing data/state ", () ->
  config =
    availabilityAreaDistance: 1
    minAvailableNumbers: 5

  beforeEach(() ->
#    state = new Reaction.State(config.availabilityAreaDistance, config.minAvailableNumbers)
  )

  it("Should correctly initialize available places after creating instance", () ->
    state = new Reaction.State(config.availabilityAreaDistance, config.minAvailableNumbers)
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

  it("Should correctly ")
)
