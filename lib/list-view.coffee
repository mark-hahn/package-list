
# lib/list-view.coffee

{View} = require 'atom-space-pen-views'

module.exports =
class ListView extends View
  
  @content: ->
    @h1 "The package-list package is Alive! It's ALIVE!"
