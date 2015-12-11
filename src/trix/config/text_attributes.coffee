Trix.config.textAttributes =
  bold:
    tagName: "b"
    inheritable: true
  italic:
    tagName: "i"
    inheritable: true
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
  frozen:
    style: { "backgroundColor": "highlight" }
