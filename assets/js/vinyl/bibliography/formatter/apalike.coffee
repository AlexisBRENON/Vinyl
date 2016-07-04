---
---

# This is my favorite bibliography style: the APA-like. It display the name and the year of the
# reference where you cite them. It's more easy to remember for papers, and very convenient for
# slideshows.
# You would probably read the vinyl/bibliography/formatter/plain file before this one as many things
# are similar.

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
# I will not explain an other time how schemas works, see the plain.coffee file more informations
        @schemas = {
          default: 'article',
          article: [{
            field: 'author',
            after: '.',
            afterSpace: ' ',
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
          }],
# Book
          book: [{
            field: 'author',
            after: '.',
            afterSpace: ' ',
          },{
            before: '(',
            field: 'year',
            after: ').',
            afterSpace: ' '
          },{
            field: 'title',
            afterSpace: ' '
          },{
            field: 'publisher',
            after: '.',
            afterSpace: ' '
          }],
# Booklet
          booklet: [{
            field: 'title',
            after: '.',
          }],
# Conference
          conference: 'inproceedings',
# InBook
          inbook: [{
            field: 'author',
            after: '.',
            afterSpace: ' ',
          },{
            before: '(',
            field: 'year',
            after: ').',
            afterSpace: ' '
          },{
            field: 'title',
            after: ',',
            afterSpace: ' '
          },{
            before: 'chapter&nbsp;',
            field: 'chapter',
            after: ',',
            afterSpace: ' '
          },{
            before: 'page&nbsp;',
            field: 'page',
            after: '.',
            afterSpace: ' '
          },{
            field: 'publisher',
            after: '.',
          }],
# InCollection
          incollection: [{
            field: 'author',
            after: '.',
            afterSpace: ' ',
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
            before: 'In&nbsp;',
            field: 'editor',
            after: ', editor,',
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
            after: '.',
          }],
# inProceedings
          inproceedings: [{
            field: 'author',
            after: '.',
            afterSpace: ' ',
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
            before: 'In ',
            field: 'booktitle',
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
            afterSpace: ' ',
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
            before: 'Master\'s thesis, ',
            field: 'school',
            after: '.',
          }],
# PhD Thesis
          phdthesis: [{
            field: 'author',
            after: '.',
            afterSpace: ' ',
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
            before: 'PhD thesis, ',
            field: 'school',
            after: '.',
          }],
# Proceedings
          proceedings: [{
            before: '(',
            field: 'year',
            after: ').',
            afterSpace: ' '
          },{
            field: 'title',
            after: '.',
          }],
# TechReport
          techreport: [{
            field: 'author',
            after: '.',
            afterSpace: ' ',
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
            before: 'Technical report, ',
            field: 'institution',
            after: '.',
          }],
# Unpublished
          unpublished: [{
            field: 'author',
            after: '.',
            afterSpace: ' ',
          },{
            field: 'title',
            after: '.',
            afterSpace: ' '
          },{
            field: 'note',
            after: '.',
          }]
        }

# Sort entries alphabetically on first author surname. Entries without date are presented
# first.
      sort: (entries) ->
        entries.sort((e1, e2) ->
          if e1.year? and not e2.year?
            return false
          else if e2.year? and not e1.year?
            return true
          else
            if e1.author? and not e2.author?
              return false
            else if e2.author? and not e1.author?
              return true
            else
              e1FirstAuthor = e1.author[0].name
              e2FirstAuthor = e2.author[0].name
              if e1FirstAuthor == e2FirstAuthor
                return e1.title > e2.title
              else
                return e1FirstAuthor > e2FirstAuthor
        )

# The ID of an entry for APA like is the last name of the first author followed by 'et al.' if there
# is multiple author, followed by the year of the publication.
# TODO: handle the case where one author published twice in the same year (add a,b,c, etc.)
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

# In APA like, author list is displayed as Surname followed by initial of first names.
      formatAuthor: BibliographyStyleAbstract.formatAuthorSurnameF

    console.log("@@ Vinyl::Bibliography::Style::ApaLike @@ Initialization: DONE")
    return BibliographyStyleApaLike
)
