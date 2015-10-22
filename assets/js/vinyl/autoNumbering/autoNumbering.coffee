---
---

define(
  "vinyl-autoNumbering"
  [
    'jquery',
  ],
  ($) ->
    numberFigures = () ->
      figuresCaptions = $('figcaption')
      for caption, i in figuresCaptions
        $(caption).html("Figure #{i+1}: " + $(caption).html())

    numberTables = () ->
      tableCaptions = $('table caption')
      for caption, i in tableCaptions
        $(caption).html("Table #{i+1}: " + $(caption).html())

    run = () ->
      numberFigures()
      numberTables()

    return {
      run: run
    }
)
