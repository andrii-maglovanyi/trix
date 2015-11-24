Trix.config.textAttributes =
  bold:
    tagName: "b"
    inheritable: true
    parser: (element) ->
      style = window.getComputedStyle(element)
      style["fontWeight"] is "bold" or style["fontWeight"] >= 700
  italic:
    tagName: "i"
    inheritable: true
    parser: (element) ->
      style = window.getComputedStyle(element)
      style["fontStyle"] is "italic"
  href:
    groupTagName: "a"
    parser: (element) ->
      {attachmentSelector} = Trix.AttachmentView
      matchingSelector = "a:not(#{attachmentSelector})"
      if link = Trix.findClosestElementFromNode(element, {matchingSelector})
        link.getAttribute("href")
  underline:
    tagName: "u"
    inheritable: true
    parser: (element) ->
      style = window.getComputedStyle(element)
      style["textDecoration"] is "underline"
  frozen:
    style: { "backgroundColor": "highlight" }
