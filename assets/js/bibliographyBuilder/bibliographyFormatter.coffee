class BibliographyFormatter
  constructor: (@format, @entries, @missingEntries) ->

  getElements: () ->
    # TODO sort @entries depending on format
    elements = switch @format
      when "num" then @createNumElements()
      when "apa" then @createApaElements()
      else @createNumElements()

  createNumElements: () ->
    elements = []
    for entry, index in @entries
      entryId = $('span', {
        class: 'ref',
        html: "[" + (index + 1) + "]"
      })
      entryAuthor = $('span', {
          class: 'ref-author',
          html: entry.author
      })
      entryTitle = $('span', {
          class: 'ref-title',
          html: entry.title
      })
      element = $('li')
      $(element).append(entryId)

