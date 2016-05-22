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

    expect(Spec.equalArrays2Dim(state.getAvailablePlaces(), expectedPlaces)).toBe(true);
  )

  it("Should correctly initialize numbers after creating instance", () ->
    expectedNumbers = [1, 2, 3, 4, 5]

    expect(Spec.equalArrays(state.getAvailableNumbers(), expectedNumbers)).toBe(true);
  )

  it("Should correctly update available numbers after setting new value", () ->
    data = [
      {
        x: 0
        y: 1
        val: 1
        expectedNumbers: [2, 3, 4, 5, 6]
      }, {
        x: 0
        y: -1
        val: 5
        expectedNumbers: [2, 3, 4, 6, 7]
      }, {
        x: 1
        y: -1
        val: 3
        expectedNumbers: [2, 4, 6, 7, 8]
      }, {
        x: -1
        y: -1
        val: 8
        expectedNumbers: [2, 4, 6, 7, 9]
      },
    ]

    for stepData in data
      state.setXY(stepData.x, stepData.y, stepData.val)
      expect(Spec.equalArrays(state.getAvailableNumbers(), stepData.expectedNumbers)).toBe(true);
  )
)
