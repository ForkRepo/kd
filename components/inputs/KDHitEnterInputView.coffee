###
todo:

  - on enter should validation fire by default??? Sinan - 6/6/2012

###


class KDHitEnterInputView extends KDInputView

  constructor:(options = {}, data)->

    options.type            or= "textarea"
    options.button          or= null
    options.showButton       ?= no
    options.label           or= null
    options.placeholder     or= ""
    options.callback        or= null
    options.togglerPartials or= ["quick update disabled","quick update enabled"]

    super options,data

    @setClass "hitenterview"

    @button = @getOptions().button ? null
    @enableEnterKey()
    @setToggler() if options.label?
    @disableEnterKey() if @getOptions().showButton

    @on "ValidationPassed", =>
      @blur()
      @getOptions().callback?.call @,@getValue()

  enableEnterKey:->
    @setClass "active"
    @hideButton() if @button
    @inputEnterToggler.$().html(@getOptions().togglerPartials[1]) if @inputEnterToggler?
    @enterKeyEnabled = yes

  disableEnterKey:->
    @unsetClass "active"
    @showButton() if @button
    @inputEnterToggler.$().html(@getOptions().togglerPartials[0]) if @inputEnterToggler?
    @enterKeyEnabled = no

  setToggler:->
    o = @getOptions()
    @inputEnterToggler = new KDCustomHTMLView
      tagName  : "a"
      cssClass : "hitenterview-toggle"
      partial  : if o.showButton then o.togglerPartials[0] else o.togglerPartials[1]
      click    : @bound "toggleEnterKey"

    @inputLabel.addSubView @inputEnterToggler

  hideButton:-> @button.hide()

  showButton:-> @button.show()

  toggleEnterKey:->
    if @enterKeyEnabled then @disableEnterKey() else @enableEnterKey()

  keyDown:(event)->
    if event.which is 13 and (event.altKey or event.shiftKey) isnt true and @enterKeyEnabled
      @emit "EnterPerformed"
      @validate()
      no
    else if event.which is 27 # escape
      @emit "EscapePerformed"