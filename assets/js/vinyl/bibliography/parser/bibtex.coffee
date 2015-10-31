---
---

define(
  [
    'bibtexParse',
    './abstract'
  ],
  (bibtexParse, BibliographyParserAbstract) ->
    console.log("@@ Vinyl::Bibliography::Parser::BibTex @@ Initialisation...")
    class BibliographyParserBibtex extends BibliographyParserAbstract
      constructor: () ->
        super("BibliographyParserBibtex")

      parse: (file) ->
        @file = file
        @parseBibtex()
        @normalizeTags()
        @toBibJson()
        return @parsedBibliography

      parseBibtex: ->
        $.ajax({
          async: false,
          url: @file,
          success: (data) =>
            @parsedBibliography = bibtexParse.toJSON(data)
        })

      normalizeTags: () ->
        # Lower case tag names
        for entry in @parsedBibliography
          entry.entryType = entry.entryType.toLowerCase()
          for key, value of entry.entryTags
            if key isnt key.toLowerCase()
              entry.entryTags[key.toLowerCase()] = value
              delete entry.entryTags[key]
      
      toBibJson: () ->
        jsonBib = {}
        for entry in @parsedBibliography
          jsonEntry = {}
          # Get the mandatory tags
          jsonEntry.id = entry.citationKey
          jsonEntry.type = entry.entryType
          
          # Parse the author field
          if entry.entryTags.author?
            jsonEntry.author = []
            # Separate each author
            for author in entry.entryTags.author.split(" and ")
              authorEntry = {}
              authorEntry.name = author
              # Find first and last names
              [authorEntry.lastname,
               authorEntry.firstname] = author.split(", ")
              jsonEntry.author.push(authorEntry)
            delete entry.entryTags.author

          # Do the same for the editor field
          if entry.entryTags.editor?
            jsonEntry.editor = []
            for editor in entry.entryTags.editor.split(" and ")
              editorEntry = {}
              editorEntry.name = editor
              [editorEntry.lastname,
               editorEntry.firstname] = editor.split(", ")
              jsonEntry.editor.push(editorEntry)
            delete entry.entryTags.editor

          # If journal is present, then add volume and pages to it
          if entry.entryTags.journal?
            jsonEntry.journal = {
              name: entry.entryTags.journal,
            }
            delete entry.entryTags.journal

          # Finally, add the other fields
          for key, value of entry.entryTags
            jsonEntry[key] = value

          # Add it in a dictionary
          jsonBib[jsonEntry.id] = jsonEntry
        # Save the dictionary
        @parsedBibliography = jsonBib

    console.log("@@ Vinyl::Bibliography::Parser::BibTex @@ Initialisation: DONE")
    return BibliographyParserBibtex
)
