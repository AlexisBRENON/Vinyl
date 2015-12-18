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

define(
  [
    'require',
    './bibtex'
  ], (require) ->
    console.log("@@ Vinyl::Bibliography::ParserFactory @@ Initialization...")
    class BibliographyParserFactory
      _instance = null # This static parameter is used to implement the singleton DP

      constructor: () ->
        @parsers = {}

# This static function replace the call to `new ...`. Call this function, it does what is needed to
# return an instance of the class. The instance returned will always be the same.
      @getInstance: ->
        if not @_instance?
          @_instance = new @
        @_instance

# This is not used for the moment. Maybe one day, every parser classes will register itself to the
# factory allowing a very easy management of new parsers.
      registerParser: (name, cls) ->
        @parsers[name] = cls

# This is the main function. It will return an instance of a parser depending on the fileFormat
# intented to be parsed.
      buildParser: (fileFormat) ->
# This is very dirty, using the register function would allow me to do it cleaner such as :
# return new @parsers[fileFormat]()
        return new (require("./#{fileFormat}"))()

# NOTES : reading my codes after few weeks, `registerParser` and `buildParser` seems to be bad
# function names. Maybe `register` and `build` would be better, allowing a better reusability of the
# code, doesn't it?

    console.log("@@ Vinyl::Bibliography::ParserFactory @@ Initialization: DONE")
    return BibliographyParserFactory
)
