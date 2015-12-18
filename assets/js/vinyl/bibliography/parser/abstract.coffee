---
---

# This is one of the most important file of the parser folder (see also parserFactory, the other
# most important file).
# This file will define an abstract base class that any parse will have to derive from and
# implement. It defines the required functions that will be called by the files using any parser.

define(
  [], () ->
    console.log("@@ Vinyl::Bibliography::Parser::Abstract @@ Initialisation...")
    class BibliographyParserAbstract
      constructor: ->

# Any class deriving from this abstract one will have to implement the `parse(file)` function which
# will read the file whose path is given in argument and then parse it to return a JS object
# containing all the bibligraphy entries.
      parse: (file) ->
        throw "Not Implemented In Abstract Class."
    
    console.log("@@ Vinyl::Bibliography::Parser::Abstract @@ Initialisation...")
    return BibliographyParserAbstract
)
