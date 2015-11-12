---
---

define(
  [
    'jquery',
    './abstract'
  ],
  ($, BibliographyStyleAbstract) ->
    console.log("@@ Vinyl::Bibliography::Style::ApaLike @@ Initialization...")

    class BibliographyStyleApaLike extends BibliographyStyleAbstract
      @formatterName = "apalike"

      constructor: () ->
        super("BibliographyStyleApaLike")
        @schemas = {
          default: 'article',
          article: [{
            field: 'author',
            after: '.',
            afterSpace: '&nbsp;',
          },{
            before: '(',
            field: 'year',
            after: ').',
            afterSpace: ' '
          },{
            field: 'title',
            after: '.',
            afterSpace: ' '
          },{
            field: 'journal',
            after: ',',
            afterSpace: ' ',
          },{
            field: 'volume',
          },{
            before: '(',
            field: 'number',
            after: ')'
          },{
            before: ':',
            field: 'pages',
            after: '.'
          }]
        }

      sort: (entries) ->
        # Sort entries alphabetically on first author surname. Entries without date are presented
        # first.
        entries.sort((e1, e2) ->
          if e1.year? and not e2.year?
            return false
          else if e2.year? and not e1.year?
            return true
          else
            e1FirstAuthor = e1.author[0].name
            e2FirstAuthor = e2.author[0].name
            if e1FirstAuthor == e2FirstAuthor
              return e1.title > e2.title
            else
              return e1FirstAuthor > e2FirstAuthor
        )

      getId: (entry) ->
        whole = document.createElement('span')
        $(whole).addClass("citation-item-id")

        before = document.createElement('span')
        $(before).addClass("before")
        $(before).html("[")
        content = document.createElement('span')
        $(content).addClass("content")
        $(content).html(
          if entry.author.length > 1
            entry.author[0].lastname + " <em>et al.</em>, #{entry.year or ""}"
          else
            "#{entry.author[0].lastname}, #{entry.year or ""}"
        )
        after = document.createElement('span')
        $(after).addClass("after")
        $(after).html(']')

        $(whole).append(before, content, after, "&nbsp;")
        return whole

      formatAuthor: BibliographyStyleAbstract.formatAuthorSurnameF

    console.log("@@ Vinyl::Bibliography::Style::ApaLike @@ Initialization: DONE")
    return BibliographyStyleApaLike
)
