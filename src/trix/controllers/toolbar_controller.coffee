{handleEvent, triggerEvent, findClosestElementFromNode} = Trix

class Trix.ToolbarController extends Trix.BasicObject
  actionButtonSelector = "button[data-action]"
  attributeButtonSelector = "button[data-attribute]"
  blockStyleSelector = "select.block"
  toolbarButtonSelector = [actionButtonSelector, attributeButtonSelector].join(", ")

  constructor: (@element) ->
    @attributes = {}
    @actions = {}

    handleEvent "mousedown", onElement: @element, matchingSelector: actionButtonSelector, withCallback: @didClickActionButton
    handleEvent "mousedown", onElement: @element, matchingSelector: attributeButtonSelector, withCallback: @didClickAttributeButton
    handleEvent "click", onElement: @element, matchingSelector: toolbarButtonSelector, preventDefault: true

  # Event handlers

  didClickActionButton: (event, element) =>
    @delegate?.toolbarDidClickButton()
    event.preventDefault()
    actionName = getActionName(element)
    @delegate?.toolbarDidInvokeAction(actionName)

  didClickAttributeButton: (event, element) =>
    @delegate?.toolbarDidClickButton()
    event.preventDefault()
    attributeName = getAttributeName(element)
    return if attributeName is "href"

    @delegate?.toolbarDidToggleAttribute(attributeName)
    @refreshAttributeButtons()

  # Action buttons

  updateActions: (@actions) ->
    @refreshActionButtons()

  refreshActionButtons: ->
    @eachActionButton (element, actionName) =>
      element.disabled = @actions[actionName] is false

  eachActionButton: (callback) ->
    for element in @element.querySelectorAll(actionButtonSelector)
      callback(element, getActionName(element))

  # Attribute buttons

  updateAttributes: (@attributes) ->
    @refreshBlockStyleSelect()
    @refreshAttributeButtons()

  refreshBlockStyleSelect: ->
    select = @element.querySelector(blockStyleSelector)
    for option in select.querySelectorAll("option")
      value = option.getAttribute("value")
      if @attributes[value]
        select.value = value
        return
    select.value = "default"

  refreshAttributeButtons: ->
    @eachAttributeButton (element, attributeName) =>
      if @attributes[attributeName]
        element.classList.add("active")
      else
        element.classList.remove("active")

  eachAttributeButton: (callback) ->
    for element in @element.querySelectorAll(attributeButtonSelector)
      callback(element, getAttributeName(element))

  applyKeyboardCommand: (keys) ->
    keyString = JSON.stringify(keys.sort())
    for button in @element.querySelectorAll("[data-key]")
      buttonKeys = button.getAttribute("data-key").split("+")
      buttonKeyString = JSON.stringify(buttonKeys.sort())
      if buttonKeyString is keyString
        triggerEvent("mousedown", onElement: button)
        return true
    false

  # General helpers

  getActionName = (element) ->
    element.getAttribute("data-action")

  getAttributeName = (element) ->
    element.getAttribute("data-attribute")
