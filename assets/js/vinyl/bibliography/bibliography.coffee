---
---

define(
  [
    'jquery',
    'bibliography/bibliographyParser',
    'bibliography/bibliographyFormatter'
  ],
  ($, BibliographyParser, BibliographyFormatter) ->
    console.log("@@ Vinyl::Bibliography @@ Initialization...")
    createBibliography = () ->
      bibList = $("#bibliography")[0]
      if not bibList?
        return

      file = $(bibList).attr("data-bibliography-file")
      fileFormat = $(bibList).attr("data-bibliography-file-format")
      format = $(bibList).attr("data-bibliography-format") or "plain"

      # Parse the bib file to a json-like dictionnary
      bibParser = new BibliographyParser(file, fileFormat)
      parsedBibliography = bibParser.parse()

      # Walk through in text references and check if it exist in bib file or not
      inTextRefs = $("span.cite[data-bibkey]")
      foundEntries = []
      missingEntries = []
      if inTextRefs? and parsedBibliography?
        for ref, refIndex in inTextRefs
          bibKeys = $(ref).attr("data-bibkey").split(' ')
          for bibKey in bibKeys
            if parsedBibliography[bibKey]?
              foundEntries.push parsedBibliography[bibKey]
            else
              missingEntries.push bibKey

      # Format the entries
      bibFormatter = new BibliographyFormatter(format, foundEntries, missingEntries)
      bibFormatter.formatEntries()
      $(bibList).append(bibFormatter.elements)

    console.log("@@ Vinyl::Bibliography @@ Initialization: DONE")
    return {
      run: createBibliography
    }
)
#
# (exports) ->
#
#   Bibliography = (file, fileFormat, format) ->
#     @file = file
#     @fileFormat = fileFormat
#
#     @displayedEntries = []
#     @notFoundEntries = []
#
#     @parseBibTex = () ->
#       $.get(
#         @file,
#         (data) ->
#           @parsedBibliography = bibtexParse.toJSON(data)
#       )
#
#     @parseBibJson = () ->
#       alert("BibJson not supported yet")
#
#     @createEntries = () ->
#       inTextRefs = $("span.ref[data-bibkey]")
#       if inTextRefs? and @parsedBibliography?
#         for ref, refIndex in inTextRefs
#           bibKey = $(ref).attr("data-bibkey")
#           if @parsedBibliography[bibKey]?
#             @displayedEntries.push @parsedBibliography[bibKey]
#           else
#             @notFoundEntries.push bibKey
#
#
#   @BibliographyFormatter = (format, displayedEntries, notFoundEntries) ->
#     @format = format
#     @displayedEntries = displayedEntries
#     @notFoundEntries = notFoundEntries
#
#
#
#   exports.displayBibliography = () ->
#     bibList = $("#bibliography")[0]
#
#     if bibList?
#       bibliographyFile = $(bibList).attr("data-bibliography-file")
#       bibliographyFileFormat = $(bibList).attr("data-bibliography-file-format")
#       bibliographyFormat = $(bibList).attr("data-bibliography-format") or "num"
#
#
#
# formatEntry = (bibEntry) ->
#   tags = bibEntry.entryTags
#   return (
#     tags.Author + ": " +
#     tags.Title + " " +
#     "(" + tags.Year + "), " +
#     tags.Journal + ((
#       " (" + tags.Number + ")"
#     ) if tags.Number? ) + " " +
#     tags.Pages
#   )
#
#
# loadBibFromBibTex = (bibFileName) ->
#   $.get(
#     bibFileName,
#     (data) ->
#       createBib(bibtexParse.toJSON(data))
#   )
#
# createBib = (bibJson) ->
#   bibliography = {}
#   bibliography[entry.citationKey] = entry for entry in bibJson
#   inTextRefs = $("span.ref")
#   bibList = $("#bibliography")[0]
#   notFoundCitation = []
#   if inTextRefs? and bibliography?
#     for ref in inTextRefs
#       refIndex = inTextRefs.index(ref)
#       bibKey = $(ref).attr("data-bibkey")
#       if bibliography[bibKey]
#         newBibEntry = $(
#           '<li>', {
#             html: "<span class=\"ref\">[" + (refIndex+1) + "]</span>" + formatEntry(bibliography[bibKey])
#           }
#         )
#
#         $(ref).html("[" + (refIndex+1) + "]")
#         $(bibList).append(newBibEntry)
#       else
#         notFoundCitation.push bibKey
#         $(ref).remove()
#
#     if notFoundCitation.length > 0
#       alert("Citation not found :\n" + notFoundCitation)
#
# build_bibliography = ( jQuery ) ->
#   bibList = $("#bibliography")[0]
#
#   if bibList?
#     bibFile = $(bibList).attr("data-bibliography-file")
#     bibFileFormat = $(bibList).attr("data-bibliography-file-format")
#
#     switch bibFileFormat
#       when "bibtex" then loadBibFromBibTex(bibFile)
#       when "bibjson" then loadBibFromBibJson(bibFile)
#       else alert("Unknown bibliography file format")
#
#
# $(document).ready(build_bibliography)
