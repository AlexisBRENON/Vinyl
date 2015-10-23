---
---

define(
  ['jquery'],
  ($) ->
    class BibliographyStylePlain
      schemas = {
        default: 'article',
        article: [
          {
            field: 'author',
            after: '. '
          },
          {
            field: 'title',
            after: '.'
          },
          {
            field: 'journal',
            after: ', '
          },
          {
            field: 'volume'
          },
          {
            before: '(',
            field: 'num',
            after: ')'
          },
          {
            before: ':',
            field: 'pages',
            after: ', '
          },
          {
            field: 'month',
            after: ' '
          },
          {
            field: 'year',
            after: '.'
          }
        ]
      }

      constructor: () ->
        @idIdx = 0
    
      getId: () -> "[#{++@idIdx}] "

      createItem = (entry) ->
        schema = @schemas[entry.entryType]
        while typeof schema == 'string'
          schema = @schemas[schema]

        result = []
        if schema?
          tmp = document.createElement('span')
          $(tmp).class("citation citation-plain citation-item-id")
          $(tmp).html(@getId())
          result.push(tmp)
          for field in schema
            whole = document.createElement('span')
            $(whole).class("citation citation-plain citation-item-#{field.field}")
             
            if field.before?
              before = document.createElement('span')
              $(before).class("before")
              $(before).html(field.before)
              $(whole).append(before)

            $(whole).append(entry[field.field])

            if field.after?
              after = document.createElement('span')
              $(after).class("after")
              $(after).html(field.after)
              $(whole).append(after)

            result.push(whole)
        else
          # TODO : output as error
          console.log("Unrecognized entryType #{entry.entryType}.")

        return result

    console.log("@@ Vinyl::Bibliography::Style::Plain @@ Initialization: DONE")
    return BibliographyStylePlain
)
