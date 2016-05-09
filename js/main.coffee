((global, $) ->
  'use strict'

  $(() ->
    config = Reaction.config
    state = new Reaction.State(config.availabilityAreaDistance, config.minAvailableNumbers)
    stateManager = new Reaction.StateManager(state)
    dataRenderer = new Reaction.DataRenderer()

    setInterval(() ->
      stateManager.tick()
      dataRenderer.render(state, $('#reaction'))
      # TODO: optimize to send only part of data
      # TODO: display data
    , config.gameTickInterval)

    #  setInterval(() ->
    #  , config.selectionInterval)
  )
)(window, jQuery)
