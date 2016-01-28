---
---

# This is the default bibliography style.
# It displays the bibliography ordered by author name, identified by a simple integer.

define(
  ['jquery',
    './abstract'],
  ($, BibliographyStyleAbstract) ->
    console.log("@@ Vinyl::Bibliography::Style::Plain @@ Initialization...")
    class BibliographyStylePlain extends BibliographyStyleAbstract
# Formatter name is not used for the moment but maybe will be in the future for factory
# registration
      @formatterName = "plain"

      constructor: () ->
        super("BibliographyStylePlain")
        @idIdx = 0 # A simple index to index entries
# Let's see an actual example of what `schemas` is used for
        @schemas = {
          default: 'article', # Here we define a default pattern, useful for non-implemented yet schemas
# Then, you have one entry for each type of bibtex types (see wikipedia for an exhaustive
# list). Here, we start with `article` which is very common. So, when you cite an article
# in you document, the reference will be built as:
          article: [{
            field: 'author', # The authors of the article ...
            after: '.', # ... terminated by a period, ...
            afterSpace: ' ' # ... followed by a normal space.
          },{
# Then, the title of the article
            field: 'title',
            after: '.',
            afterSpace: ' '
          },{
# The journal in which it has been published
            field: 'journal',
            after: ',',
            afterSpace: ' '
          },{
# The volume without any surrounding character or space
            field: 'volume'
          },{
# The number of the volumes, between braces
            before: '(',
            field: 'num',
            after: '):'
          },{
# The pages
            field: 'pages',
            after: ',',
            afterSpace: ' '
          },{
# The date, as month and year
            field: 'month',
            afterSpace: ' '
          },{
            field: 'year',
            after: '.'
          }],
# A book as some specifities.
# Sometimes, authors are not set, or editors, if both are the same. So we use a function which
# return the right field however it's defined.
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
          }],
# A booklet
          booklet: [{
            field: 'title',
            after: '.',
          }],
# A conference
# A conference citation use the same scheme than an inproceedings one. Just
# use the name of the base, link will be done
          conference: 'inproceedings',
# InBook
          inbook: [{
            field: 'author',
            after: '.',
            afterSpace: ' '
          },{
            field: 'title',
            after: ',',
            afterSpace: ' '
          },{
            before: 'Chapter&nbsp;',
            field: 'chapter',
            after: ',',
            afterSpace: ' '
          },{
            before: 'page&nbsp;',
            field: 'pages',
            after: '.',
            afterSpace: ' '
          },{
            field: 'publisher',
            after: ',',
            afterSpace: ' '
          },{
            field: 'year',
            after: '.',
          }],
# InCollection
          incollection: [{
            field: 'author',
            after: '.',
            afterSpace: ' '
          },{
            field: 'title',
            after: '.',
            afterSpace: ' '
          },{
            before: 'In&nbsp;',
            field: 'editor',
            after: 'editor,',
            afterSpace: ' '
          },{
            field: 'booktitle',
            after: ',',
            afterSpace: ' '
          },{
            before: 'pages&nbsp;',
            field: 'pages',
            after: '.',
            afterSpace: ' '
          },{
            field: 'publisher',
            after: ',',
            afterSpace: ' '
          },{
            field: 'year',
            after: '.',
          }],
# InProceedings
          inproceedings: [{
            field: 'author',
            after: '.',
            afterSpace: ' '
          },{
            field: 'title',
            after: '.',
            afterSpace: ' '
          },{
            before: 'In&nbsp;',
            field: 'booktitle',
            after: ',',
            afterSpace: ' '
          },{
            before: 'pages&nbsp;',
            field: 'pages',
            after: '.',
            afterSpace: ' '
          },{
            field: 'organization',
            after: ',',
            afterSpace: ' '
          },{
            field: 'year',
            after: '.',
          }],
# Manual
          manual: [{
            field: 'title',
            after: '.',
          }],
# Master Thesis
          masterthesis: [{
            field: 'author',
            after: '.',
            afterSpace: ' '
          },{
            field: 'title',
            after: '. Master\'s Thesis,',
            afterSpace: ' '
          },{
            field: 'school',
            after: ',',
            afterSpace: ' '
          },{
            field: 'year',
            after: '.',
          }],
# PhD Thesis
          phdthesis: [{
            field: 'author',
            after: '.',
            afterSpace: ' '
          },{
            field: 'title',
            after: '. PhD Thesis,',
            afterSpace: ' '
          },{
            field: 'school',
            after: ',',
            afterSpace: ' '
          },{
            field: 'year',
            after: '.',
          }],
# Proceedings
          proceedings: [{
            field: 'title',
            after: ',',
            afterSpace: ' '
          },{
            field: 'year',
            after: '.'
          }],
# Tech Report
          techreport: [{
            field: 'author',
            after: '.',
            afterSpace: ' '
          },{
            field: 'title',
            after: '.',
            afterSpace: ' '
          },{
            before: 'Technical report, ',
            field: 'institution',
            after: ',',
            afterSpace: ' '
          },{
            field: 'year',
            after: '.',
          }],
# Unpublished
          unpublished: [{
            field: 'author',
            after: '.',
            afterSpace: ' '
          },{
            field: 'title',
            after: '.',
            afterSpace: ' '
          },{
            field: 'note',
            after: '.',
          }]
        }

# Sort entries alphabetically on first author surname
      sort: (entries) ->
        return entries.sort((e1, e2) ->
          e1FirstAuthor = e1.author[0].name
          e2FirstAuthor = e2.author[0].name
          if e1FirstAuthor == e2FirstAuthor
            return e1.title > e2.title
          else
            return e1FirstAuthor > e2FirstAuthor
        )

# Here the id is just an integer. We enclose it in brackets and set some classes to style it.
# Nothing more.
      getId: (entry) ->
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

# The function to format authors is overriden
      formatAuthor: BibliographyStyleAbstract.formatAuthorFirstnameSurname

# Return author or editor depending on which one is defined for a book
      bookAuthorAndEditor: (entry) ->
        if not entry.author?
          "#{entry.editor} and editor"
        else if not entry.editor?
          "#{entry.author} and editor"
        else
          entry.entryTags.author


    console.log("@@ Vinyl::Bibliography::Style::Plain @@ Initialization: DONE")
    return BibliographyStylePlain
)
