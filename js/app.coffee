((global, $) ->
  'use strict'

  $(() ->
    config = Reaction.config
    state = new Reaction.State(config.availabilityAreaDistance, config.minAvailableNumbers)
    stateManager = new Reaction.StateManager(state)
    dataRenderer = new Reaction.DataRenderer(
      $('#reaction-grid'),
      $('.container').width(),
      $('.container').height() - $('.nav-wrapper').height(),
    )

    mainLoop = () ->
      stateManager.tick()
      dataRenderer.render(state)

    mainLoop()

    setInterval(() ->
      mainLoop()
    , config.gameTickInterval)
  )
)(window, jQuery)
