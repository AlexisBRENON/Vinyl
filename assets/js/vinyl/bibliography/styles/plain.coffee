---
---

define(
  ['jquery',
    './abstract'],
  ($, BibliographyStyleAbstract) ->
    class BibliographyStylePlain extends BibliographyStyleAbstract
      constructor: () ->
        super("BibliographyStylePlain")
        @idIdx = 0
        @schemas = {
          default: 'article',
          article: [
            {
              field: 'author',
              after: '.',
              afterSpace: ' '
            },
            {
              field: 'title',
              after: '.',
              afterSpace: ' '
            },
            {
              field: 'journal',
              after: ',',
              afterSpace: ' '
            },
            {
              field: 'volume'
            },
            {
              before: '(',
              field: 'num',
              after: '):'
            },
            {
              field: 'pages',
              after: ',',
              afterSpace: ' '
            },
            {
              field: 'month',
              afterSpace: ' '
            },
            {
              field: 'year',
              after: '.'
            }
          ]
        }

      getId: () ->
        whole = document.createElement('span')
        $(whole).addClass("citation-item-id")

        before = document.createElement('span')
        $(before).addClass("before")
        $(before).html("[")
        content = document.createElement('span')
        $(content).addClass("content")
        $(content).html(++@idIdx)
        after = document.createElement('span')
        $(after).addClass("after")
        $(after).html(']')

        $(whole).append(before, content, after, "&nbsp;")
        return whole

    console.log("@@ Vinyl::Bibliography::Style::Plain @@ Initialization: DONE")
    return BibliographyStylePlain
)
