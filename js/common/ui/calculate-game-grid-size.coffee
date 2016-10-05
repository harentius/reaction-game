((global, $) ->
  'use strict'

  global.app ||= {}
  global.app.ui ||= {}
  global.app.ui.calculateGameGridSize = () ->
    $container = $('.content-wrapper')

    return {
      width: $container.width()
      height: $container.height() - $('.nav-wrapper').height()
    }
)(window, jQuery)
