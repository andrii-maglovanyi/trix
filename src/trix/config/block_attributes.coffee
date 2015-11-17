Trix.config.blockAttributes = attributes =
  default:
    tagName: "p"
    parse: false
  #quote:
  #  tagName: "blockquote"
  #  nestable: true
  #code:
  #  tagName: "pre"
  #  text:
  #    plaintext: true
  bulletList:
    tagName: "ul"
    parse: false
  bullet:
    tagName: "li"
    listAttribute: "bulletList"
    test: (element) ->
      Trix.tagName(element.parentNode) is attributes[@listAttribute].tagName
  numberList:
    tagName: "ol"
    parse: false
  number:
    tagName: "li"
    listAttribute: "numberList"
    test: (element) ->
      Trix.tagName(element.parentNode) is attributes[@listAttribute].tagName
  heading1:
    tagName: "h1"
    test: (element) ->
      Trix.tagName(element) is "h1"
  heading2:
    tagName: "h2"
    test: (element) ->
      Trix.tagName(element) is "h2"
  heading3:
    tagName: "h3"
    test: (element) ->
      Trix.tagName(element) is "h3"
