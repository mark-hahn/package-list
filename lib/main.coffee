
# lib/main

HtmlTab = require './package-list-disable'
{CompositeDisposable} = require 'atom'

module.exports =
  activate: -> 
    @subs = new CompositeDisposable
    @subs.add atom.commands.add 'atom-workspace', 'package-list-disable:open': ->
      atom.workspace.getActivePane().activateItem new HtmlTab "I'm Alive!"

  deactivate: ->
    @subs.dispose()
    