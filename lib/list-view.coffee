
# lib/list-view.coffee

{$, $$} = require 'space-pen'
{View}  = require 'atom-space-pen-views'
SubAtom = require 'sub-atom'

module.exports =
class ListView extends View
  
  @content: ->
    @div class: 'list-view editor-colors', =>
      @div class: 'pkglist-header',
        'Package List -- 
          Click to enable/disable --
          Ctrl-Click to open docs --
          Ctrl-Alt-Click to uninstall.'
      @table class: 'pkglist-table', outlet: 'table'
    
  initialize: (@list) -> @setEvents()
    
  drawTable: ->
    @scrolltop = @[0].scrollTop
    @list.getPackages()
    numPkgs = @list.packageNames.length
    @table.empty()
    numCols = Math.max 1, Math.floor @width() / 200
    colWidth = (@width() - 50) / numCols
    numRows = Math.ceil numPkgs / numCols
    list = @list
    html = ''
    for row in [0...numRows]
        html += '<tr>'
        for col in [0...numCols]
          if (name = list.packageNames[row + col*numRows])
            pkg = list.packages[name]
            html += '<td width="' + colWidth + '" data-name="' + name + '">'
            html +=   '<label>'
            html +=     '<input type="checkbox"' + 
                              (if pkg.enabled then '" checked>' else '">')
            html +=     pkg.prettyName
            html +=   '</label>'
            html += '</td>'
        html += '</tr>'
    @table.append $ html
    @[0].scrollTop = @scrolltop
    
  setEvents: ->
    @subs = new SubAtom
    @subs.add @table, 'click', 'td', (e) =>
      packageName = $(e.target).closest('td').attr 'data-name'
      if e.ctrlKey
        if e.altKey
          if @list.uninstall packageName
            @drawTable()
        else
          @list.openURL packageName
        false
      
    @subs.add @table, 'change', 'input', (e) =>
      if not e.ctrlKey and not e.altKey
        @list.toggle $(e.target).closest('td').attr 'data-name'
        @drawTable()
        false

    @sizeInterval = setInterval =>
      width = @width()
      if width isnt @oldWidth
        @oldWidth = width
        @drawTable()
    , 500

  destroy: ->
    clearInterval @sizeInterval
    @subs.dispose()