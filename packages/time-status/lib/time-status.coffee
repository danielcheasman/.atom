TimeStatusView = require './time-status-view'

class TimeStatus
  attach: ->
    statusBar = document.querySelector(".status-bar-right")
    if statusBar and not @view
      @view = new TimeStatusView statusBar

  # Activates the package.
  activate: ->
    @disposable = atom.packages.onDidActivateInitialPackages => @attach()
    @attach()

  # Deactivates the package.
  deactivate: ->
    @disposable?.dispose()
    @view?.destroy()
    @view = null

module.exports = new TimeStatus()
