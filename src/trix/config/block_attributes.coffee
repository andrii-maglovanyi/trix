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
    excludesAttributes: ["heading1", "heading2", "heading3"]
    test: (element) ->
      Trix.tagName(element.parentNode) is attributes[@listAttribute].tagName
  numberList:
    tagName: "ol"
    parse: false
  number:
    tagName: "li"
    listAttribute: "numberList"
    excludesAttributes: ["heading1", "heading2", "heading3"]
    test: (element) ->
      Trix.tagName(element.parentNode) is attributes[@listAttribute].tagName
  heading1:
    heading: true
    tagName: "h1"
    excludesAttributes: ["bulletList", "bullet", "numberList", "number"]
    test: (element) ->
      Trix.tagName(element) is "h1"
  heading2:
    heading: true
    tagName: "h2"
    excludesAttributes: ["bulletList", "bullet", "numberList", "number"]
    test: (element) ->
      Trix.tagName(element) is "h2"
  heading3:
    heading: true
    tagName: "h3"
    excludesAttributes: ["bulletList", "bullet", "numberList", "number"]
    test: (element) ->
      Trix.tagName(element) is "h3"
  attachment:
    tagName: "div"
    className: "shareitem"
