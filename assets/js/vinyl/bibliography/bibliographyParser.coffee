---
---

define(['jquery', 'bibtexParse'], ($, bibtexParse) ->
  console.log("@@ Vinyl::Bibliography::Parser @@ Initialization...")
  class BibliographyParser
    constructor: (@file, @fileFormat) ->
      @parsedBibliography = {}

    parseBibTex: () ->
      $.ajax({
        async: false,
        url: @file,
        success: (data) =>
          @parsedBibliography = bibtexParse.toJSON(data)
      })
      for entry in @parsedBibliography
        entry.entryType = entry.entryType.toLowerCase()
        for key, value of entry.entryTags
          if key isnt key.toLowerCase()
            entry.entryTags[key.toLowerCase()] = value
            delete entry.entryTags[key]
      return this

    parseBibJson: () ->
      alert("BibJson not supported yet")

    parse: () ->
      switch @fileFormat
        when "bibtex" then @parseBibTex()
        when "bibjson" then @parseBibJson()
        else alert("Bib file format not recognized : " + @fileFormat)
      dict = {}
      dict[entry.citationKey] = entry for entry in @parsedBibliography
      @parsedBibliography = dict

  console.log("@@ Vinyl::Bibliography::Parser @@ Initialization: DONE")
  return BibliographyParser
)
