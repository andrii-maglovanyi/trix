#= require trix/models/text

{arraysAreEqual, extend} = Trix

class Trix.AttachmentBlock extends Trix.Block
  constructor: (@attachment) ->
    super(null, ["attachment"])

  hasAttachment: ->
    true

  getAttachment: ->
    @attachment

  copyWithText: ->
    new @constructor @attachment

  copyWithAttributes: ->
    new @constructor @attachment

  isEmpty: ->
    false

  isListItem: ->
    false

  toJSON: ->
    attachment: @attachment.toJSON()

  toString: ->
    Trix.OBJECT_REPLACEMENT_CHARACTER

  # Splittable

  getLength: ->
    1

  canBeConsolidatedWith: ->
    false

  # Grouping

  canBeGrouped: ->
    false

  canBeGroupedWith: ->
    false
