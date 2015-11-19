editorModule "Attachments", template: "editor_with_image"

editorTest "moving an image by drag and drop", (expectDocument) ->
  typeCharacters "!", ->
    moveCursor direction: "right", times: 1, (coordinates) ->
      img = document.activeElement.querySelector("img")
      triggerEvent(img, "mousedown")
      after 1, ->
        dragToCoordinates coordinates, ->
          expectDocument "!a#{Trix.OBJECT_REPLACEMENT_CHARACTER}b\n"

editorTest "removing an image", (expectDocument) ->
  after 20, ->
    closeButton = findElement(".#{Trix.config.css.classNames.attachment.removeButton}")
    clickElement closeButton, ->
      expectDocument "ab\n"

getFigure = ->
  findElement("figure")

findElement = (selector) ->
  getEditorElement().querySelector(selector)
