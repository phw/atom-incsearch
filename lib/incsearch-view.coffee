$ = require 'jquery'
{Emitter} = require 'atom'

module.exports =
class IncsearchView
  constructor: (serializedState) ->
    @emitter = new Emitter
    @createLayout()

  createLayout: ->
    # view layout
    @container = $ '<div/>', {
      class: 'incsearch'
    }

    layout = $ '<div/>', class: 'layout'

    @input = $ '<input/>', {
      class: 'native-key-bindings'
      placeholder: 'Search'
    }

    @buttons = $ '<div/>', {
      class: 'btn-group buttons',
    }

    # show all matches button
    @btnHighlight = $ '<button/>', class: 'btn highlight-all', title: 'Show all matches'
    @btnHighlight.append $ '<span/>', class: 'icon icon-eye'
    @btnHighlight.click (e) =>
      @btnHighlight.toggleClass 'selected'
      @input.focus()
      @emitter.emit 'option-change', option: 'highlight_all', value: @btnHighlight.hasClass('selected')

    @buttons.append @btnHighlight

    @btnRegex = $ '<button/>', class: 'btn regex', title: 'Search using regular expression', text: '.*'
    @btnRegex.click (e) =>
      @btnRegex.toggleClass 'selected'
      @input.focus()
      @emitter.emit 'option-change', option: 'regex', value: @btnRegex.hasClass('selected')

    @buttons.append @btnRegex

    @btnCase = $ '<button/>', class: 'btn case_sensitive', title: 'Case sensitive search', text: 'Aa'
    @btnCase.click (e) =>
      @btnCase.toggleClass 'selected'
      @input.focus()
      @emitter.emit 'option-change', option: 'case_sensitive', value: @btnCase.hasClass('selected')

    @buttons.append @btnCase

    @matches = $ '<div/>', class: 'matches', text: '0 matches'

    layout.append @input
    layout.append @matches
    layout.append @buttons

    # closing on escape press
    @input.on 'keydown', (e) =>
      if e.keyCode == 27
        @emitter.emit 'close'
      if e.keyCode == 13
        @emitter.emit 'accept'
      if e.keyCode == 40 and e.altKey
        @emitter.emit 'next-match'
      if e.keyCode == 38 and e.altKey
        @emitter.emit 'prev-match'

    # query change
    @input.on 'keyup', (e) =>
      # exclude command keys
      return if e.keyCode == 114 or e.keyCode == 16

      @emitter.emit 'input-change', @input.val()

    @container.append layout

  updateMatches: (matches) ->
    if not matches
      @matches.text '0 matches'
      return

    if matches.current
      text = "#{matches.current} of #{matches.count} match"
    else
      text = "#{matches.count} #{if matches.count == 1 then 'match' else 'matches'}"

    @matches.text text

  # event handlers
  onClose: (callback) -> @emitter.on 'close', callback
  onAccept: (callback) -> @emitter.on 'accept', callback
  onOptionChange: (callback) -> @emitter.on 'option-change', callback
  onInputChange: (callback) -> @emitter.on 'input-change', callback
  onNextMatch: (callback) -> @emitter.on 'next-match', callback
  onPrevMatch: (callback) -> @emitter.on 'prev-match', callback

  serialize: ->

  destroy: ->
    @container.remove()

  getElement: ->
    @container
