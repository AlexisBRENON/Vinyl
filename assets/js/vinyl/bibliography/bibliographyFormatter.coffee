---
---

define(['jquery',
  'bibliography/styles/plain'
  ], ($) ->
  console.log("@@ Vinyl::Bibliography::Formatter @@ Initialization...")
  class BibliographyFormatter
    constructor: (@format, @entries, @missingEntries) ->
      @elements = []

    formatEntries: () ->
      # TODO sort @entries depending on format
      @createElements()
      if @missingEntries.length > 0
        alert("Bibkeys not found: ", @missingEntries)
      return this

    createElements: () ->
      alreadySeenKeys = []
      style = new (require("bibliography/styles/#{@format}"))()
      for entry in style.sort(@entries)
        if not (entry.citationKey in alreadySeenKeys)
          alreadySeenKeys.push(entry.citationKey)
          item = style.createItem(entry)

          element = document.createElement('li')
          $(element).attr('id', entry.citationKey)
          $(element).addClass("#{@format}-style-citation-item")
          $(element).addClass("#{entry.entryType}-citation-item")
          $(element).append item.elements[fieldName] for fieldName in item.fields

          for inTextRef in $("span.cite[data-bibkey~='#{entry.citationKey}']")
            $(inTextRef).addClass("#{@format}-style-cite") if not $(inTextRef).hasClass("#{@format}-cite")
            beforeText = $(item.elements.id).children('.before').html()
            afterText = $(item.elements.id).children('.after').html()
            citationId = $(item.elements.id).children('.content').html()
            citationLink = document.createElement('a')
            $(citationLink).attr('href', "##{entry.citationKey}")
            $(citationLink).html(citationId)

            if $(inTextRef).html() == ""
              $(inTextRef).append("#{beforeText}", citationLink, "#{afterText}")
            else
              $(inTextRef).html(
                $(inTextRef).html().slice(0,-1*afterText.length) + "," + citationLink.outerHTML + afterText
              )

          @elements.push(element)

  console.log("@@ Vinyl::Bibliography::Formatter @@ Initialization: DONE")
  return BibliographyFormatter
)
