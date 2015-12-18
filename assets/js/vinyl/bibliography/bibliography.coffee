---
---

# You're still here. Congrats, it's the beginning of interesting parts.
#
# The bibliography part of Vinyl handle the creation of the bibliography. It relies on two parts:
#   * a parser which read your bibliography file to find cited entries;
#   * a formatter which will format citation and display them in your document.
# See each sub-folder for more info on each part.

define(
  [
    'jquery',
    './parser/parserFactory',
    './formatter/formatterFactory'
  ],
  ($, ParserFactory, FormatterFactory) ->
    console.log("@@ Vinyl::Bibliography @@ Initialization...")
# As in the vinyl/vinyl file, here we only define a facade for the Bibliography part with only one
# function exported as `run` but defined as `createBibliography`
    createBibliography = () ->
# First of all, check if any bibliography is requested. If not, you're done.
      bibList = $("#bibliography")[0] # TODO : check class instead of ID to allow multiple bibliographies
      if not bibList?
        return

# The bibliography element will have different attributes
      file = $(bibList).attr("data-bibliography-file") or "bibliography.bib" # The file containing all entries
      fileFormat = $(bibList).attr("data-bibliography-file-format") or "bibtex" # The file format (bibtex, bibjson, etc.)
      format = $(bibList).attr("data-bibliography-style") or "plain" # The format to use for citations

# Let's ask to the Parser factory the right parser depending on the file format defined
      parser = ParserFactory.getInstance().buildParser(fileFormat)
# Then, parse the bibliography file. This will return a big JS object containing each entries.
# I'm trying to return it following the same scheme that bibjson, so look at the website (TODO) for
# more info. You can also read the vinyl/bibliography/parser files to learn more.
      parsedBibliography = parser.parse(file)
      if parsedBibliography?
# Now, you look for the citations in the whole document
        inTextRefs = $("span.cite[data-bibkey]") # We take only those with a data-bibkey attribute
        usedEntries = {}
        missingEntries = []
        if inTextRefs?
          for ref, refIndex in inTextRefs
# For every citation, we get bibkeys (it may have multiple bibkeys for one citation
# element)
            bibKeys = $(ref).attr("data-bibkey").split(' ')
            for bibKey in bibKeys
              if parsedBibliography[bibKey]?
# If the bibkey exist in the parsed file, save the corresponding bibliography entry
# Here, usedEntries is an object to avoid duplicate entry if the same entry is cited
# multiple times
                usedEntries[bibKey] = parsedBibliography[bibKey]
              else
# Else save it to allow some informative warning message
                missingEntries.push bibKey
# Now, we transform the usedEntries object to a list
        usedEntries = (value for _,value of usedEntries)

# At this point, you have a list of all entries that are cited in the document. Now, you have to
# format them.

# As for the parser, ask the Formatter factory to build a formatter depending on the defined format.
        formatter = FormatterFactory.getInstance().buildFormatter(format)
# Ask the formatter to create items which will be added to the bibliography list
# The createItems function also add the references in the text, in place of citation.
# This maybe can be done in a better way. Feel free to propose a better architecture.
        $(bibList).append(formatter.createItems(usedEntries))

# Finally, alert if some entries were not found. This is weird with a big `alert` window, but
# prevent to forgot some citation because of a typo in the bibkey.
        if missingEntries.length > 0
          alert("Bibkeys not found: #{missingEntries}")
      else
        console.log("@@ Vinyl::Bibliography @@ ERROR @@ Unable to parse `" + file + "`")

    console.log("@@ Vinyl::Bibliography @@ Initialization: DONE")
    return {
      run: createBibliography
    }
)

