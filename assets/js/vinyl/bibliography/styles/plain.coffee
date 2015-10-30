---
---

define(
  ['jquery',
    './abstract'],
  ($, BibliographyStyleAbstract) ->
    console.log("@@ Vinyl::Bibliography::Style::Plain @@ Initialization...")
    class BibliographyStylePlain extends BibliographyStyleAbstract
      constructor: () ->
        super("BibliographyStylePlain")
        @idIdx = 0
        @schemas = {
          default: 'article',
          article: [{
            field: 'author',
            after: '.',
            afterSpace: ' '
          },{
            field: 'title',
            after: '.',
            afterSpace: ' '
          },{
            field: 'journal',
            after: ',',
            afterSpace: ' '
          },{
            field: 'volume'
          },{
            before: '(',
            field: 'num',
            after: '):'
          },{
            field: 'pages',
            after: ',',
            afterSpace: ' '
          },{
            field: 'month',
            afterSpace: ' '
          },{
            field: 'year',
            after: '.'
          }],
          proceedings: [{
            field: 'author',
            after: '.',
            afterSpace: ' '
          },{
            field: 'title',
            after: '.',
            afterSpace: ' '
          },{
            before: 'In ',
            field: 'series',
            after: ',',
            afterSpace: ' '
          },{
            before: 'volume ',
            field: 'volume',
            after: ',',
            afterSpace: ' '
          },{
            before: 'pages ',
            field: 'pages',
            after: ',',
            afterSpace: ' ',
          },{
            field: 'address',
            after: ','
            afterSpace: ' ',
          },{
            field: 'month',
            afterSpace: '&nbsp;',
          },{
            field: 'year',
            after: '.'
          }],
          book: [{
            field: 'author',
            function: @bookAuthorAndEditor,
            after: '.',
            afterSpace: ' '
          },{
            field: 'title',
            after: '.',
            afterSpace: ' ',
          },{
            field: 'publisher',
            after: ',',
            afterSpace: ' '
          },{
            field: 'year',
            after: '.'
          }]
        }

      sort: (entries) ->
        # Sort entries alphabetically on first author surname
        entries.sort((e1, e2) ->
          e1FirstAuthor = e1.entryTags.author[0]
          e2FirstAuthor = e2.entryTags.author[0]
          if e1FirstAuthor == e2FirstAuthor
            return e1.entryTags.title > e2.entryTags.title
          else
            return e1FirstAuthor > e2FirstAuthor
        )

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

      formatAuthor: BibliographyStyleAbstract.formatAuthorFirstnameSurname

      bookAuthorAndEditor: (entry) ->
        if not entry.entryTags.author?
          "#{entry.entryTags.editor} and editor"
        else if not entry.entryTags.editor?
          "#{entry.entryTags.author} and editor"
        else
          entry.entryTags.author


    console.log("@@ Vinyl::Bibliography::Style::Plain @@ Initialization: DONE")
    return BibliographyStylePlain
)
