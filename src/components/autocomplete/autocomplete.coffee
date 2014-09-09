KDInputView = require './../inputs/inputview.coffee'

module.exports = class KDAutoComplete extends KDInputView
  mouseDown: ->
    @focus()

  setDomElement:->
    @domElement = $ "<div class='kdautocompletewrapper clearfix'><input type='text' placeholder='#{@getOptions().placeholder}' class='kdinput text'/></div>"

  setDomId:->
    @$input().attr "id",@getDomId()
    @$input().attr "name",@getName()
    @$input().data "data-id",@getId()

  setDefaultValue:(value) ->
    @inputDefaultValue = value
    @setValue value

  $input:-> @$("input").eq(0)
  getValue:-> @$input().val()
  setValue:(value)-> @$input().val(value)

  bindEvents:->
    super @$input()

  # FIX THIS: on blur dropdown should disappear but the
  # problem is if you the lines below, blur fires earlier than
  # KDAutoCompleteListItemViewClick and that breaks mouse selection
  # on autocomplete list
  blur:(pubInst,event)->
    @unsetClass "focus"
    # @hideDropdown()
    # log pubInst,event.target,"blur"
    # @destroyDropdown()
    yes

  focus:(pubInst,event)->
    @setClass "focus"
    super

  keyDown:(event)->
    (KD.getSingleton "windowController").setKeyView @
    yes

  getLeftOffset:->
    @$input().prev().width()

  destroyDropdown:->
    @dropdown.destroy() if @dropdown?
    @dropdownPrefix = ""
    @dropdown = null

  setPlaceholder:(value)->
    @$input()[0].setAttribute "placeholder", value

  setFocus:->
    super
    @$input().trigger "focus"

  setBlur:->
    super
    @$input().trigger "blur"
