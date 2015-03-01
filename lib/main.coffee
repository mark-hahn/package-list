
# lib/main

ListItem = require './list-item'
SubAtom  = require 'sub-atom'

module.exports =
  activate: -> 
    @subs = new SubAtom
    @subs.add atom.commands.add 'atom-workspace', 'package-list:open': ->
      atom.workspace.getActivePane().activateItem new ListItem "Installed Packages"

  deactivate: ->
    @subs.dispose()
    