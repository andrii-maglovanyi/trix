{makeElement} = Trix
{classNames} = Trix.config.css

MimeTypes = require("mimetypes")

class Trix.AttachmentView extends Trix.ObjectView
  @attachmentSelector: "[data-rel=attachment]"

  constructor: ->
    super
    @attachment = @object
    @attachment.uploadProgressDelegate = this

  createContentNodes: ->
    mimeType = @attachment.getContentType()

    icon = makeElement
      tagName: "img"
      attributes:
        class: "fileicon mrm"
        src: MimeTypes.iconForMimeType(mimeType)

    title = makeElement
      tagName: "a"
      textContent: @attachment.getFilename()
      attributes:
        class: "title"
        "data-href": @attachment.getAttribute("url")

    if MimeTypes.shouldOpenInBrowser(mimeType)
      title.setAttribute("target", "_blank")
    else
      title.setAttribute("data-mimetype", mimeType)
      title.setAttribute("download", @attachment.getFilename())

    [icon, title]

  createNodes: ->
    wrapper = makeElement
      tagName: "div"
      attributes:
        class: "attachment-wrapper"
        contenteditable: false

    comment = document.createComment("block")
    wrapper.appendChild(comment)

    shareItem = makeElement
      tagName: "div"
      attributes:
        class: @getClassName()
      data:
        eid: @attachment.getAttribute("eid")
        mimeType: @attachment.getContentType()
        rel: "attachment"

    shareItem.appendChild(node) for node in @createContentNodes()

    data =
      trixId: @attachment.id

    if @attachment.isPending()
      @progressElement = makeElement
        tagName: "progress"
        attributes:
          class: classNames.attachment.progressBar
          value: @attachment.getUploadProgress()
          max: 100
        data:
          trixMutable: true
          trixStoreKey: @attachment.getCacheKey("progressElement")

      shareItem.appendChild(@progressElement)
      data.trixSerialize = false

    shareItem.dataset[key] = value for key, value of data

    wrapper.appendChild(shareItem)

    [wrapper]

  getClassName: ->
    names = [
      Trix.config.blockAttributes.attachment.className,
      if @attachment.isPreviewable() then "image" else "file"
    ]
    names.join(" ")

  getHref: ->
    unless htmlContainsTagName(@attachment.getContent(), "a")
      @attachment.getHref()

  createCursorTarget: ->
    makeElement
      tagName: "span"
      textContent: Trix.ZERO_WIDTH_SPACE
      data:
        trixCursorTarget: true
        trixSerialize: false

  findProgressElement: ->
    @findElement()?.querySelector("progress")

  # Attachment delegate

  attachmentDidChangeUploadProgress: ->
    value = @attachment.getUploadProgress()
    @findProgressElement()?.value = value

htmlContainsTagName = (html, tagName) ->
  div = makeElement("div")
  div.innerHTML = html ? ""
  div.querySelector(tagName)
