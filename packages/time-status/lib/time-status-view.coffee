class TimeStatusView
  constructor: (@statusBar) ->
    @el = document.createElement 'span'
    @el.classList.add 'time-status', 'inline-block'
    @attach()

  attach: ->
    @statusBar?.appendChild @el
    @getTime()
    @timer = setInterval @getTime, 1000

  detach: ->
    if @timer
      clearInterval @timer
      @timer = null
    @el.remove()

  destroy: ->
    @detach()
    @el = null

  getTime: =>
    language = atom.config.get('time-status.language') or navigator.language
    @el.textContent = (new Date).toLocaleTimeString language,
      hour: '2-digit'
      minute:'2-digit'

module.exports = TimeStatusView
