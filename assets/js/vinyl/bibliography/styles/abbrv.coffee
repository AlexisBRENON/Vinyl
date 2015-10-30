---
---

define(
  ['./abstract',
  './plain'],
  (BibliographyStyleAbstract, BibliographyStylePlain) ->
    console.log("@@ Vinyl::Bibliography::Style::Abbrv @@ Initialization...")
    class BibliographyStyleAbbrv extends BibliographyStylePlain
      constructor: () ->
        super("BibliographyStyleAbbrv")

      formatAuthor: BibliographyStyleAbstract.formatAuthorFSurname
    
    console.log("@@ Vinyl::Bibliography::Style::Abbrv @@ Initialization: DONE")
    return BibliographyStyleAbbrv
)
