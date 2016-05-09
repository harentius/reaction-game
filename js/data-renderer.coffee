((global) ->
  'use strict'

  class DataRenderer
    render: (state, $table) ->
      data = state.getData()

      return if !data

      minX = data[0][0]
      maxX = data[0][0]
      minY = data[0][1]
      maxY = data[0][1]
  
      for val in data
        minX = val[0] if val[0] < minX
        maxX = val[0] if val[0] > maxX
        minY = val[1] if val[1] < minY
        maxY = val[1] if val[1] > maxY
  
      i = minY
      tableContent = ''
  
      while i <= maxY
        j = minX
        rowContent = ''
  
        while j <= maxX
          rowContent += "<td>#{@._getValueOrEmpty(j, i, data)}</td>"
          j++
  
        tableContent += "<tr>#{rowContent}</tr>"
        i++

      $table.html(tableContent)
        
    _getValueOrEmpty: (x, y, data) ->
      for val in data
        return val[2] if val[0] == x and val[1] == y
    
      return ''


  global.Reaction ||= {}
  global.Reaction.DataRenderer = DataRenderer
)(window)
