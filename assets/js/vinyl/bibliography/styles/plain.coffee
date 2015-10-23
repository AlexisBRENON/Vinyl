---
---

define(
  ['jquery'],
  ($) ->
    class BibliographyStylePlain
      constructor: () ->
        @idIdx = 0

      createItem: (entry) ->
        schema = null
        if not BibliographyStylePlain.schemas[entry.entryType]?
          schema = BibliographyStylePlain.schemas.default
        else
          schema = BibliographyStylePlain.schemas[entry.entryType]
        result = {
          fields: [],
          elements: {}
        }

        while typeof schema == 'string'
          schema = BibliographyStylePlain.schemas[schema]

        if schema?
          result.fields.push('id')
          result.elements.id = @getId()

          for field in schema
            if entry.entryTags[field.field]?
              whole = document.createElement('span')
              $(whole).addClass("citation-item-#{field.field}")

              $(whole).append(field.beforeSpace) if field.beforeSpace?
              if field.before?
                before = document.createElement('span')
                $(before).addClass("before")
                $(before).html(field.before)
                $(whole).append(before)

              content = document.createElement('span')
              $(content).addClass("content")
              $(content).html(entry.entryTags[field.field])
              $(whole).append(content)

              if field.after?
                after = document.createElement('span')
                $(after).addClass("after")
                $(after).html(field.after)
                $(whole).append(after)
              $(whole).append(field.afterSpace) if field.afterSpace?

              result.fields.push(field.field)
              result.elements[field.field] = whole
        else
          # TODO : output as error
          console.log("Unrecognized entryType #{entry.entryType}.")


        return result

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

    console.log("@@ Vinyl::Bibliography::Style::Plain @@ Initialization: DONE")
    return BibliographyStylePlain
)
