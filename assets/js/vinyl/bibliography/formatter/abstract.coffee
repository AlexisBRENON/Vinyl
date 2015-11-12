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

      createItems: (entries) ->
        items = []
        alreadySeenKeys = []
        for entry in @sort(entries)
          if entry.id not in alreadySeenKeys
            # Avoid duplicated entries
            alreadySeenKeys.push(entry.id)

            # Create the content of the item
            item = @createItem(entry)
            # Add the content to a li node with right attributes
            element = document.createElement('li')
            $(element).attr('id', entry.id)
            $(element).addClass("#{this.constructor.formatterName}-style-citation-item")
            $(element).addClass("#{entry.type}-citation-item")
            $(element).append(item.elements[field]) for field in item.fields

            @updateReferences(entry, item.elements.id)

            items.push(element)
        return items

      updateReferences: (entry, itemId) ->
          # Update all references to this entry to display the id
          for inTextRef in $("span.cite[data-bibkey~='#{entry.id}']")
            # Style it according to the right style
            $(inTextRef).addClass("#{this.constructor.formatterName}-style-cite")
            # Get the id elements
            beforeText = $(itemId).children('.before').html()
            afterText = $(itemId).children('.after').html()
            citationId = $(itemId).children('.content').html()
            # Create the link to the reference
            citationLink = document.createElement('a')
            $(citationLink).attr('href', "##{entry.id}")
            $(citationLink).html(citationId)

            # Create the text for the in-text citation
            if $(inTextRef).html() == ""
              # No previous citation, just add one
              $(inTextRef).append("#{beforeText}", citationLink, "#{afterText}")
            else
              # Remove the closing element, add the new id, and the closing element back
              $(inTextRef).html(
                $(inTextRef).html().slice(0,-1*afterText.length) + ", " + citationLink.outerHTML + afterText
              )

          return null

      createItem: (entry) ->
        schema = null
        if not @schemas[entry.type]?
          schema = @schemas.default
        else
          schema = @schemas[entry.type]
        while typeof schema == 'string'
          schema = @schemas[schema]
        result = {
          html: "",
          fields: [],
          elements: {}
        }

        if schema?
          result.fields.push('id')
          result.elements.id = @getId(entry)
          result.html = $(result.elements.id).html()

          for field in schema
            if entry[field.field]?
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
                if field.function? then field.function(entry) else entry[field.field]
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
              result.html += $(whole).html()
        else
          # TODO : output as error
          console.log("Unrecognized entry type #{entry.type}.")

        return result

      sort: (entries) -> entries

      getId: (entry) ->
        throw "#{this} :: getId(entry) must be overrode"

      format: (field, value) ->
        if @formatFunctions[field]?
          @formatFunctions[field](value)
        else
          ""

      formatAddress:      (address) -> address
      formatAnnote:       (annote) -> annote
      formatAuthor:       (author) -> @formatAuthorFirstnameSurname(author)
      formatBookTitle:    (bookTitle) -> bookTitle
      formatChapter:      (chapter) -> chapter
      formatCrossRef:     (crossRef) -> crossRef
      formatEdition:      (edition) -> edition
      formatEditor:       (editor) -> editor
      formatHowPublished: (hP) -> hP
      formatInstitution:  (institution) -> institution
      formatJournal:      (journal) -> journal.name
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
          if author.firstname.search(/[- ]/) >= 0
            # It's a composed name
            names = author.firstname.split(/[- ]/)
            for name in names
              result += "#{name.charAt(0)}. "
            result += author.lastname
          else
            result += "#{author.firstname.charAt(0)}. #{author.lastname}"
          return result)(author) for author in authors)

        if abbrvAuthors.length == 1
          result = abbrvAuthors[0]
        else if abbrvAuthors.length == 2
          result = abbrvAuthors.join(" and ")
        else
          result = abbrvAuthors[0..-1].join(', ')
          result += ", and #{abbrvAuthors[-1..][0]}"
        return result
      
      @formatAuthorSurnameF: (authors) ->
        abbrvAuthors = (((author) ->
          result = author.lastname + ","
          if author.firstname.search(/[- ]/) >= 0
            # It's a composed name
            names = author.firstname.split(/[- ]/)
            for name in names
              result += "&nbsp;#{name.charAt(0)}."
          else
            result += "&nbsp;#{author.firstname.charAt(0)}."
          return result)(author) for author in authors)

        if abbrvAuthors.length == 1
          result = abbrvAuthors[0]
        else if abbrvAuthors.length == 2
          result = abbrvAuthors.join(" and ")
        else
          result = abbrvAuthors[0..-1].join(', ')
          result += ", and #{abbrvAuthors[-1..][0]}"
        return result

      @formatAuthorFirstnameSurname: (authors) ->
        if authors.length == 1
          result = authors[0].name
        else if authors.length == 2
          result = (author.name for author in authors).join(" and ")
        else
          result = (author.name for author in authors)[0..-1].join(', ')
          result += ", and #{authors[-1..][0]}"
        return result
)
