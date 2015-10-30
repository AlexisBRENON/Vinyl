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
              contentText = @format(
                field.field,
                if field.function? then field.function(entry) else entry.entryTags[field.field]
              )
              $(content).addClass("content")
              $(content).html(contentText)
              $(whole).append(content)

              if field.after? and not contentText.endsWith(field.after)
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

      sort: (entries) -> entries

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

      @formatAuthorFSurname: (authors) ->
        abbrvAuthors = (((author) ->
          result = ""
          [last, first] = author.split(", ")
          if first.search(/[- ]/) >= 0
            # It's a composed name
            names = first.split(/[- ]/)
            for name in names
              result += "#{name.charAt(0)}. "
            result += last
          else
            result += "#{first.charAt(0)}. #{last}"
          return result)(author) for author in authors)

        if abbrvAuthors.length == 1
          result = abbrvAuthors[0]
        else if abbrvAuthors.length == 2
          result = abbrvAuthors.join(" and ")
        else
          result = abbrvAuthors.slice(0,-1).join(', ')
          result += ", and #{abbrvAuthors[abbrvAuthors.length-1]}"
        return result

      @formatAuthorFirstnameSurname: (authors) ->
        if authors.length == 1
          result = authors[0]
        else if authors.length == 2
          result = authors.join(" and ")
        else
          result = authors.slice(0,-1).join(', ')
          result += "and #{authors[authors.length-1]}"
        return result
)