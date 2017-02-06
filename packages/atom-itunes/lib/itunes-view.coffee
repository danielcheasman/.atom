{View} = require 'atom-space-pen-views'
itunesDesktop = require './itunes-desktop'

module.exports =
class itunesView extends View
  @content: ->
    @div class: 'itunes', =>
      @div outlet: 'container', class: 'itunes-container inline-block', =>
        @span outlet: 'soundBars', class: 'itunes-sound-bars', =>
          @span class: 'itunes-sound-bar'
          @span class: 'itunes-sound-bar'
          @span class: 'itunes-sound-bar'
          @span class: 'itunes-sound-bar'
          @span class: 'itunes-sound-bar'

        @a outlet: 'currentlyPlaying', href: 'javascript:',''

  initialize: (statusBar) ->
    @statusBar = statusBar
    @currentTrack = {}
    @currentState = null
    @dataSequence = ['track', 'artist', 'album']
    @currentDataIndex = 0
    @refreshInterval = atom.config.get('atom-itunes.itunesRefreshInterval')
    @dataSequenceInterval = @refreshInterval * 2
    @elapsed = 0
    @initiated = false
    @itunesDesktop = new itunesDesktop

    @addCommands()
    @attach()

  destroy: ->
    @detach()

  # Commands
  addCommands: ->
    # Defaults
    for command in itunesDesktop.COMMANDS
      do (command) =>
        atom.commands.add 'atom-workspace', "itunes:#{command.name}", => @itunesDesktop[command.name]()

    # Open current track with iTunes.app
    atom.commands.add 'atom-workspace', 'itunes:open-current-track', => @openWithitunes()

  # Attach the view to the farthest right of the status bar
  attach: =>
    @statusBarTile = @statusBar.addRightTile(item: this, priority: -1001)

    # Navigate to current track inside itunes
    @currentlyPlaying.on 'click', (e) =>
      @itunesDesktop.openWindow()

    # Toggle equalizer on config change
    atom.config.observe 'atom-itunes.showEqualizer', (value) =>
      @toggleEqualizer(value)

    # Toggle musical notes on config change
    atom.config.observe 'atom-itunes.showNotes', (value) =>
      @toggleNotes(value)

  toggleEqualizer: (show) ->
    if show
      @soundBars.removeAttr('data-hidden')
    else
      @soundBars.attr('data-hidden', true)

  toggleNotes: (show) ->
    if show
      @currentlyPlaying.attr('class', 'notes')
    else
      @currentlyPlaying.removeAttr('class')

  attached: =>
    setInterval =>
      @itunesDesktop.currentState (state) =>
        if state isnt @currentState
          @currentState = state
          @soundBars.attr('data-state', state)

        # iTunes is closed
        if state is undefined
          if @initiated
            @initiated = false
            @currentTrack = {}
            @container.removeAttr('data-initiated')
          return

        # iTunes is paused, but we know about the current track
        return if state is 'paused' and @initiated

        # Get current track data
        @itunesDesktop.currentlyPlaying (data) =>
          return unless (data.artist and data.track and data.album)

          # Check if user wants to cycle track info
          if atom.config.get('atom-itunes.cycleTrackInfo') == true
            @showText = data[@dataSequence[@currentDataIndex]]
          else
            @showText = "#{data.artist} - #{data.track}"

          # Check if we need to move on to the next data item
          if @elapsed >= @dataSequenceInterval
            if @currentDataIndex++ >= (@dataSequence.length - 1)
              @currentDataIndex = 0
            @elapsed = 0
          else
            @elapsed += @refreshInterval

          # Set text
          @currentlyPlaying.text @showText

          return if data.artist is @currentTrack.artist and data.track is @currentTrack.track
          @currentTrack = data

          # Display container when hidden
          return if @initiated
          @initiated = true
          @container.attr('data-initiated', true)
    , @refreshInterval
