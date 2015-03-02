
# lib/list-item.coffee

ListView = require './list-view'
shell      = require 'shell'
{execSync} = require 'child_process'

module.exports =
class ListItem
  constructor: (@tabTitle) ->
    
  getTitle:     -> @tabTitle
  getViewClass: -> ListView
  
  getPackages: ->
    @packages = {}
    @packageNames = []
    for metadata in atom.packages.getAvailablePackageMetadata()
      {name, version, homepage, repository, theme} = metadata
      enabled = not atom.packages.isPackageDisabled name
      parts = []
      for part in name.split '-'
        parts.push part[0].toUpperCase() + part[1...]
      prettyName = parts.join ' '
      @packages[name] = {version, homepage, repository, theme, prettyName, enabled}
      @packageNames.push name
    @packageNames.sort()
    
  toggle: (name) ->
    if atom.packages.isPackageDisabled name  
      atom.packages.enablePackage name
      @activate name
      
      # console.log 1, atom.packages.isPackageDisabled name
      # atom.packages.enablePackage name
      # console.log 2, atom.packages.isPackageDisabled name
      # setTimeout (=> @activate name), 300
      # console.log 3, atom.packages.isPackageDisabled name
    else
      atom.packages.disablePackage name
      @deactivate name
      # setTimeout (=> atom.packages.disablePackage name), 300
      
  activate: (name) -> 
    try
      atom.packages.loadPackage name
    catch e
    try
      pack = atom.packages.getLoadedPackage name
      pack.activationDeferred ?= resolve:(->), reject:(->)
      pack.activateNow()
    catch e
    
  deactivate: (name) ->
    try
      atom.packages.deactivatePackage name
    catch e
  
  openURL: (name) ->
    url = 'https://atom.io/packages/' + name
    if atom.packages.isPackageLoaded 'web-browser'
      atom.workspace.open url
    else
      shell.openExternal url
      
  uninstall: (name) ->
    uninstall = atom.confirm
      message: 'Package List: Confirm Uninstall\n'
      detailedMessage: 'Are you sure you want to uninstall the pkg ' + name + '?'
      buttons: ['Cancel', 'Uninstall']
    if uninstall is 0 then return false
    try
      console.log execSync 'apm uninstall ' + name, encoding: 'utf8'
    catch e
      atom.confirm
        message: 'Package List: Error During Uninstall\n'
        detailedMessage: e.message
        buttons: ['OK']
      return false
    true
