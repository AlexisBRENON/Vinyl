---
---

define(
  [],
  () -> 
    class BibliographyStyleAbstract
      constructor: () ->
        @schemas = {default: {}}
        @formatFunctions = {
          'address': @formatAddress,
          'annote': @formatAnnote,
          'author': @formatAuthor,
          'booktitle': @formatBookTitle,
          'chapter': @formatChapter,
          'crossRef': @formatCrossRef,
          'edition': @formatEdition,
          'editor': @formatEditor,
          'hP': @formatHowPublished,
          'institution': @formatInstitution,
          'journal': @formatJournal,
          'month': @formatMonth,
          'note': @formatNote,
          'number': @formatNumber,
          'org': @formatOrganization,
          'pages': @formatPages,
          'publisher': @formatPublisher,
          'school': @formatSchool,
          'series': @formatSeries,
          'title': @formatTitle,
          'type': @formatType,
          'volume': @formatVolume,
          'year': @formatYear
        }

      createItem: (entry) ->
        schema = null
        if not @schemas[entry.entryType]?
          schema = @schemas.default
        else
          schema = @schemas[entry.entryType]
        while typeof schema == 'string'
          schema = @schemas[schema]
        result = {
          fields: [],
          elements: {}
        }

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
              $(content).html(
                @format(field.field, entry.entryTags[field.field])
              ) 
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
        throw "#{this} :: getId() must be overrode"

      format: (field, value) ->
        if @formatFunctions[field]?
          @formatFunctions[field](value)
        else
          ""

      formatAddress:      (address) -> address
      formatAnnote:       (annote) -> annote
      formatAuthor:       (author) -> author
      formatBookTitle:    (bookTitle) -> bookTitle
      formatChapter:      (chapter) -> chapter
      formatCrossRef:     (crossRef) -> crossRef
      formatEdition:      (edition) -> edition
      formatEditor:       (editor) -> editor
      formatHowPublished: (hP) -> hP
      formatInstitution:  (institution) -> institution
      formatJournal:      (journal) -> journal
      formatMonth:        (month) -> month
      formatNote:         (note) -> note
      formatNumber:       (number) -> number
      formatOrganization: (org) -> org
      formatPages:        (pages) -> pages
      formatPublisher:    (publisher) -> publisher
      formatSchool:       (school) -> school
      formatSeries:       (series) -> series
      formatTitle:        (title) -> title
      formatType:         (type) -> type
      formatVolume:       (volume) -> volume
      formatYear:         (year) -> year
)
