((global, $) ->
  'use strict'

  global.Reaction ||= {}
  global.Reaction.ui ||= {}
  global.Reaction.ui.calculateGameGridSize = () ->
    $container = $('.container')

    return {
      width: $container.width()
      height: $container.height() - $('.nav-wrapper').height()
    }
)(window, jQuery)
