#= require trix/controllers/attachment_editor_controller

{handleEvent, makeElement, tagName} = Trix
{keyNames} = Trix.InputController
{lang} = Trix.config
{classNames} = Trix.config.css

class Trix.AttachmentEditorController extends Trix.BasicObject
  constructor: (@attachment, @element, @container) ->
    @element = @element.firstChild if tagName(@element) is "a"
    @install()

  undoable = (fn) -> ->
    commands = fn.apply(this, arguments)
    commands.do()
    @undos ?= []
    @undos.push(commands.undo)

  install: ->
    @makeElementMutable()
    @addRemoveButton()

  makeElementMutable: undoable ->
    do: => @element.dataset.trixMutable = true
    undo: => delete @element.dataset.trixMutable

  addRemoveButton: undoable ->
    removeButton = makeElement(tagName: "a", textContent: lang.remove, className: classNames.attachment.removeButton, attributes: { href: "#", title: lang.remove })
    handleEvent("click", onElement: removeButton, withCallback: @didClickRemoveButton)
    do: => @element.appendChild(removeButton)
    undo: => @element.removeChild(removeButton)

  didClickRemoveButton: (event) =>
    event.preventDefault()
    event.stopPropagation()
    @delegate?.attachmentEditorDidRequestRemovalOfAttachment(@attachment)

  uninstall: =>
    undo() while undo = @undos.pop()
    @delegate?.didUninstallAttachmentEditor(this)
