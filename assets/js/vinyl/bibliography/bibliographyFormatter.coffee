---
---

define(['jquery'], ($) ->
  console.log("@@ Vinyl::Bibliography::Formatter @@ Initialization...")
  class BibliographyFormatter
    constructor: (@format, @entries, @missingEntries) ->
      @elements = []

    formatEntries: () ->
      # TODO sort @entries depending on format
      switch @format
        when "num" then @createNumElements()
        when "apa" then @createApaElements()
        else @createNumElements()
      if @missingEntries.length > 0
        alert("Bibkeys not found: ", @missingEntries)
      return this

    createNumElements: () ->
      alreadySeenKeys = []
      for entry, index in @entries
        if not (entry.citationKey in alreadySeenKeys)
          alreadySeenKeys.push(entry.citationKey)
          inTextRef = $("a.ref[data-bibkey='#{entry.citationKey}']")

          entryId = document.createElement('span')
          $(entryId).addClass('ref')
          $(entryId).html("[" + (index + 1) + "]")
          $(inTextRef).html($(entryId).html())
          $(inTextRef).attr('href', "##{entry.citationKey}")

          entryAuthor = document.createElement('span')
          $(entryAuthor).addClass('ref-author')
          $(entryAuthor).html(entry.entryTags.author)

          entryTitle = document.createElement('span')
          $(entryTitle).addClass('ref-title')
          $(entryTitle).html(entry.entryTags.title)

          element = document.createElement('li')
          $(element).attr('id', entry.citationKey)
          $(element).append(entryId, " ", entryAuthor, ": ", entryTitle)
          @elements.push(element)

  console.log("@@ Vinyl::Bibliography::Formatter @@ Initialization: DONE")
  return BibliographyFormatter
)
