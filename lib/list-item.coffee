
# lib/list-item.coffee

ListView = require './list-view'

module.exports =
class ListItem
  constructor: (@tabTitle) ->
    
  getTitle:     -> @tabTitle
  getViewClass: -> ListView
  
