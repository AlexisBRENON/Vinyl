---
---

# You would probably read the vinyl/bibliography/formatter/plain before this one as it's a subclass
# of the Plain formatter

define(
  ['./abstract',
  './plain'],
  (BibliographyStyleAbstract, BibliographyStylePlain) ->
    console.log("@@ Vinyl::Bibliography::Style::Abbrv @@ Initialization...")
    class BibliographyStyleAbbrv extends BibliographyStylePlain
      @formatterName = "abbrv"

      constructor: () ->
        super("BibliographyStyleAbbrv")

# Abbrv formatter is very similar to plain one. The only difference is the name of the authors, we
# display only the initial of the firstname (that why it's called abbreviated bibliography style).
      formatAuthor: BibliographyStyleAbstract.formatAuthorFSurname
    
    console.log("@@ Vinyl::Bibliography::Style::Abbrv @@ Initialization: DONE")
    return BibliographyStyleAbbrv
)
