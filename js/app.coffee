((global, $) ->
  'use strict'

  $(() ->
    config = Reaction.config
    state = new Reaction.State(config.availabilityAreaDistance, config.minAvailableNumbers)
    stateManager = new Reaction.StateManager(state)
    dataRenderer = new Reaction.DataRenderer($('#reaction-grid'), $('.container'))

    mainLoop = () ->
      stateManager.tick()
      dataRenderer.render(state)

      data = state.getData()
      for v1, k1 in data
        for v2, k2 in data
          if (k1 != k2) and ((v1[0] == v2[0]) and (v1[1] == v2[1]))
            console.log v1[0], v1[1], v1[2]
            console.log v2[0], v2[1], v2[2]



    mainLoop()

    setInterval(() ->
      mainLoop()
    , config.gameTickInterval)
  )
)(window, jQuery)
