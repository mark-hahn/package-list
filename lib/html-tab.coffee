
# lib/package-list-disable

HtmlTabView = require './package-list-disable-view'

module.exports =
class HtmlTab
  constructor: (@tabTitle) ->
    
  getTitle:     -> @tabTitle
  getViewClass: -> HtmlTabView
  
