---
---

# This is the second part of Vinyl. Its job is to auto-number figures, tables and co. and create
# some link to them (with the right number/identifier) in the document.
# It is in a very early development stage and so quiet dirty and/or incomplete.
# Actually, autonumbering can be achieved thanks to CSS counters. So this Vinyl module will just
# have to create the links to them (with the right ID) in the future.
define(
  [
    'jquery',
  ],
  ($) ->
# As its name can help you to guess, this function create numerotation for figures.
    numberFigures = () ->
      figuresCaptions = $('figcaption')
      for caption, i in figuresCaptions
        figure = $(caption).parent("figure")
# TODO: l18n and numbering customization
        figName = "Figure #{i+1}"
        $(caption).prepend("#{figName}: ")
        updateLinks($(figure).attr('id'), figName)

# One more time, no surprises here, is auto-numbers the tables
    numberTables = () ->
      tableCaptions = $('table caption')
      for caption, i in tableCaptions
        table = $(caption).parent("table")
# TODO: l18n and numbering customization
        tableName = "Table #{i+1}"
        $(caption).prepend("#{tableName}: ")
        updateLinks($(table).attr('id'), tableName)

# This one is a little bit more cryptic. Given the id of a figure/table, defined by you (the writer
# of the document), it updates any link to it setting the right name "Figure X"/"Table X".
    updateLinks = (id, name) ->
      references = $("a.ref[href='#{id}']")
      for ref in references
        $(ref).attr('href', "##{id}") #TODO: Ask the user to set the hash directly in document
        $(ref).html(name)

# Entry point which run every number* function
    run = () ->
      numberFigures()
      numberTables()

    return {
      run: run
    }
)
