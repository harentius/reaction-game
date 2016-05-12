((global, $) ->
  'use strict'

  $(() ->
    config = Reaction.config
    state = new Reaction.State(config.availabilityAreaDistance, config.minAvailableNumbers)
    stateManager = new Reaction.StateManager(state)
    dataRenderer = new Reaction.DataRenderer($('#reaction-grid'))

    setInterval(() ->
      stateManager.tick()
      dataRenderer.render(state)
    , config.gameTickInterval)
  )
)(window, jQuery)
