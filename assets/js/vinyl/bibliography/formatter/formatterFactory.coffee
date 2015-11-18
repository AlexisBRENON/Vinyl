---
---

define(
  [
    'require',
    './plain',
    './abbrv',
    './apalike'
  ], (require) ->
    console.log("@@ Vinyl::Bibliography::FormatterFactory @@ Initialization...")
    class BibliographyFormatterFactory
      _instance = null

      constructor: ->

      @getInstance: ->
        if not @_instance?
          @_instance = new @
        @_instance

      buildFormatter: (format) ->
        new (require("./#{format}"))()

    console.log("@@ Vinyl::Bibliography::FormatterFactory @@ Initialization: DONE")
    return BibliographyFormatterFactory
)
