---
---

define(
  [
    'jquery',
  ],
  ($) ->
    numberFigures = () ->
      figuresCaptions = $('figcaption')
      for caption, i in figuresCaptions
        figure = $(caption).parent("figure")
        # TODO: l18n and numbering customization
        figName = "Figure #{i+1}"
        $(caption).prepend("#{figName}: ")
        updateLinks($(figure).attr('id'), figName)

    numberTables = () ->
      tableCaptions = $('table caption')
      for caption, i in tableCaptions
        table = $(caption).parent("table")
        # TODO: l18n and numbering customization
        tableName = "Table #{i+1}"
        $(caption).prepend("#{tableName}: ")
        updateLinks($(table).attr('id'), tableName)

    updateLinks = (id, name) ->
      references = $("a.ref[href='#{id}']")
      for ref in references
        $(ref).attr('href', "##{id}")
        $(ref).html(name)

    run = () ->
      numberFigures()
      numberTables()

    return {
      run: run
    }
)
