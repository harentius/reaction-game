describe("Testing data/state ", () ->
  it("Should correctly initialize available places after creating instance", () ->
    data =
      availabilityAreaDistance: 1
      minAvailableNumbers: 5
      expectedPlaces: [
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

    containsPlace = (place, places) ->
      for p in places
        return true if p[0] == place[0] && p[1] == place[1]

      return false

    state = new Reaction.State(data.availabilityAreaDistance, data.minAvailableNumbers)

    for place in state.getAvailablePlaces()
      expect(containsPlace(place, data.expectedPlaces)).toBe(true);
  )
)
