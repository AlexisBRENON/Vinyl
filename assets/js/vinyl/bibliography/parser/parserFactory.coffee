---
---

define(
  [
    'require',
    './bibtex'
  ], (require) ->
    console.log("@@ Vinyl::Bibliography::ParserFactory @@ Initialization...")
    class BibliographyParserFactory
      _instance = null

      constructor: () ->
        @parsers = {}

      @getInstance: ->
        if not @_instance?
          @_instance = new @
        @_instance

      registerParser: (name, cls) ->
        @parsers[name] = cls

      buildParser: (fileFormat) ->
        return new (require("./#{fileFormat}"))()

    console.log("@@ Vinyl::Bibliography::ParserFactory @@ Initialization: DONE")
    return BibliographyParserFactory
)
