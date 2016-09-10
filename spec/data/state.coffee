describe("Testing data/state ", () ->
  state = null
  config =
    availabilityAreaDistance: 1
    minAvailableNumbers: 5

  beforeEach(() ->
    state = new Reaction.State(config.availabilityAreaDistance, config.minAvailableNumbers)
  )

  it("Should correctly initialize numbers after creating instance", () ->
    expectedNumbers = [1, 2, 3, 4, 5]

    expect(Spec.equalArrays(state.getAvailableNumbers(), expectedNumbers)).toBe(true);
  )
)
