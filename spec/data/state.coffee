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

  data = [
    {
      x: 0
      y: 0
      val: 1
      expectedNumbers: [2, 3, 4, 5, 6]
      expectedAvailablePlaces: [
        [-1, -1]
        [-1, 0]
        [0, -1]
        [0, 1]
        [1, 0]
        [1, 1]
        [-1, 1]
        [1, -1]
      ]
      expectedData: [[0, 0, 1]]
    }, {
      x: 0
      y: 1
      val: 2
      expectedNumbers: [3, 4, 5, 6, 7]
      expectedAvailablePlaces: [
        [-1, -1]
        [-1, 0]
        [0, -1]
        [1, 0]
        [1, 1]
        [-1, 1]
        [1, -1]
      ]
      expectedData: [[0, 0, 1], [0, 1, 2]]
    }, {
      x: 0
      y: -1
      val: 5
      expectedNumbers: [3, 4, 6, 7, 8]
      expectedAvailablePlaces: [
        [-1, -1]
        [-1, 0]
        [1, 0]
        [1, 1]
        [-1, 1]
        [1, -1]
      ]
      expectedData: [[0, 0, 1], [0, 1, 2], [0, -1, 5]]
    }, {
      x: 1
      y: -1
      val: 3
      expectedNumbers: [4, 6, 7, 8, 9]
      expectedAvailablePlaces: [
        [-1, -1]
        [-1, 0]
        [1, 0]
        [1, 1]
        [-1, 1]
        [0, -2]
        [1, -2]
        [2, -2]
        [2, -1]
        [2, 0]
      ]
      expectedData: [[0, 0, 1], [0, 1, 2], [0, -1, 5], [1, -1, 3]]
    }, {
      x: -1
      y: -1
      val: 8
      expectedNumbers: [4, 6, 7, 9, 10]
      expectedAvailablePlaces: [
        [-1, 0]
        [1, 0]
        [1, 1]
        [-1, 1]
        [0, -2]
        [1, -2]
        [2, -2]
        [2, -1]
        [2, 0]
      ]
      expectedData: [[0, 0, 1], [0, 1, 2], [0, -1, 5], [1, -1, 3], [-1, -1, 8]]
    },
  ]

  it("Should correctly update available numbers, places and data after setting new value", () ->
    for stepData in data
      state.setXY(stepData.x, stepData.y, stepData.val)
      expect(Spec.equalArrays(state.getAvailableNumbers(), stepData.expectedNumbers)).toBe(true);
      expect(Spec.equalArrays2Dim(state.getAvailablePlaces(), stepData.expectedAvailablePlaces)).toBe(true);
      expect(Spec.equalArrays2Dim(state.getData(), stepData.expectedData)).toBe(true);
  )
)
