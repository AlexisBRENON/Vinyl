---
---

define(
  [], () ->
    console.log("@@ Vinyl::Bibliography::Parser::Abstract @@ Initialisation...")
    class BibliographyParserAbstract
      constructor: ->

      parse: (file) ->
        throw "Not Implemented In Abstract Class."
    
    console.log("@@ Vinyl::Bibliography::Parser::Abstract @@ Initialisation...")
    return BibliographyParserAbstract
)
