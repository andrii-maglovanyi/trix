#= require trix/views/attachment_view
#= require trix/views/previewable_attachment_view
#= require trix/views/text_view

{makeElement} = Trix

class Trix.BlockView extends Trix.ObjectView
  constructor: ->
    super
    @block = @object
    @attributes = @block.getAttributes()

  createNodes: ->
    if @block.hasAttachment()
      return @createAttachmentNodes()

    comment = document.createComment("block")
    nodes = [comment]

    if @block.isEmpty()
      nodes.push(makeElement("br"))
    else
      textConfig = Trix.config.blockAttributes[@block.getLastAttribute()]?.text
      textView = @findOrCreateCachedChildView(Trix.TextView, @block.text, {textConfig})
      nodes.push(textView.getNodes()...)
      nodes.push(makeElement("br")) if @shouldAddExtraNewlineElement()

    if @attributes.length
      nodes
    else
      element = makeElement(Trix.config.blockAttributes.default.tagName)
      element.appendChild(node) for node in nodes
      [element]

  createAttachmentNodes: ->
    attachment = @block.getAttachment()
    constructor = if attachment.isPreviewable()
      Trix.PreviewableAttachmentView
    else
      Trix.AttachmentView

    view = @findOrCreateCachedChildView(constructor, attachment)
    view.getNodes()

  createContainerElement: (depth) ->
    attribute = @attributes[depth]
    config = Trix.config.blockAttributes[attribute]
    makeElement(config.tagName)

  # A single <br> at the end of a block element has no visual representation
  # so add an extra one.
  shouldAddExtraNewlineElement:->
    /\n\n$/.test(@block.toString())
