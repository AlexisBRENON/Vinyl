---
---

# This is a factory singleton. Learn more about design patterns (DPs) to understand what I mean here.
# The singleton is to say that you don't have to call the constructor of this class, in any case (in
# some languages like Java or C++, the constructor would even not be callable from other classes),
# instead you call the static function getInstance which will return a instance which is the same
# for everyone.
# The factory is to say that the instance have a `build` function taking one or more parameters
# which will create a new instance of a class depending on the parameters given. This is a unique
# entry point for a countless number of similar classes implementing the same abstract
# class/interface.
# Yes, these comments are the same than the one in vinyl/bibliography/parser/parserFactory, but they
# are very similar classes which do quiet the same job.

define(
  [
    'require',
    './plain',
    './abbrv',
    './apalike'
  ], (require) ->
    console.log("@@ Vinyl::Bibliography::FormatterFactory @@ Initialization...")
    class BibliographyFormatterFactory
      _instance = null # Used for singleton DP implementation

# Constructor must not be called from outside this class. No need to do a `new ...`, use getInstance
# instead.
      constructor: ->

# Static function which return the unique instance of the factory
      @getInstance: ->
        if not @_instance?
          @_instance = new @
        @_instance

# Return an instance of a formatter class depending on the citation format requested.
      buildFormatter: (format) ->
        new (require("./#{format}"))()

    console.log("@@ Vinyl::Bibliography::FormatterFactory @@ Initialization: DONE")
    return BibliographyFormatterFactory
)
