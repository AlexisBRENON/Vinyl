---
---

define(
  [
    'jquery',
    'bibliography/parser/parserFactory',
    'bibliography/formatter/formatterFactory'
  ],
  ($, ParserFactory, FormatterFactory) ->
    console.log("@@ Vinyl::Bibliography @@ Initialization...")
    createBibliography = () ->
      bibList = $("#bibliography")[0]
      if not bibList?
        return

      file = $(bibList).attr("data-bibliography-file")
      fileFormat = $(bibList).attr("data-bibliography-file-format")
      format = $(bibList).attr("data-bibliography-style") or "plain"

      # Parse the bib file to a json-like dictionnary
      parser = ParserFactory.getInstance().buildParser(fileFormat)
      parsedBibliography = parser.parse(file)

      # Walk through in-text references and check if it exist in bib file or not
      inTextRefs = $("span.cite[data-bibkey]")
      usedEntries = {}
      missingEntries = []
      if inTextRefs? and parsedBibliography?
        for ref, refIndex in inTextRefs
          bibKeys = $(ref).attr("data-bibkey").split(' ')
          for bibKey in bibKeys
            if parsedBibliography[bibKey]?
              usedEntries[bibKey] = parsedBibliography[bibKey]
            else
              missingEntries.push bibKey
      usedEntries = (value for _,value of usedEntries)

      # Format the entries
      formatter = FormatterFactory.getInstance().buildFormatter(format)
      $(bibList).append(formatter.createItems(usedEntries))

      if missingEntries.length > 0
        alert("Bibkeys not found: #{missingEntries}")

    console.log("@@ Vinyl::Bibliography @@ Initialization: DONE")
    return {
      run: createBibliography
    }
)

