---
---

# Let's the hard things begin. This file is the base abstract class for any formatter. Any formatter
# will have to inherit from this class and implement/override some functions.
# This class also define some common used functions. Let's see deeper...

define(
  [],
  () ->
    class BibliographyStyleAbstract
# This default constructor will have to be called by the sub-constructors
      constructor: () ->
# The base constructor defines :
#   the `schemas` variable: this variable will describe how an entry should be built - the
#   order of the fields, the separator - depending on its type (article, proceedings, etc.)
#   the `formatFunctions` will contains, for each entry field, a function which will return
#   the field formatted approprietally.
# See some implementations (plain, apalike) for examples.
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

# This is the main function of this class. It's called by the bibliography module and
# will generates the list items (li) element containing a reference.
# It will also display the right index in the document, where a citation is refered.
      createItems: (entries) ->
        items = []
        alreadySeenKeys = []
# Start by sorting entries. Some formatters list references by apparition order, others
# by authors name, etc. The sort function will be overriden by formatter to meet their
# needs.
        for entry in @sort(entries)
# Here we avoid duplicated reference if two citation refer to the same reference.
          if entry.id not in alreadySeenKeys
            alreadySeenKeys.push(entry.id)

# Create the content of the item. The construction is a little bit complicated, so the
# definition is in a separate function
            item = @createItem(entry)

# Actually create the list item element and add ID and classes
            element = document.createElement('li')
            $(element).attr('id', entry.id) # We use the bibkey as the reference id to create anchors
# Some classes allow a very powerful customization. Each formatter comes with its
# CSS to style the references.
            $(element).addClass("#{this.constructor.formatterName}-style-citation-item")
            $(element).addClass("#{entry.type}-citation-item")
# `item` is a big object (see the createItem function). Here, you walk through the
# list of fields that must be displayed and add the previously created span element to
# our li element.
# In other words, we construct a full reference line from blocks of text for each
# entry field.
            $(element).append(item.elements[field]) for field in item.fields

# This call will add indexes in the document where there are citations of this entry
            @updateReferences(entry, item.elements.id)

            items.push(element)
        return items

# This function, as the prevous one hasn't to be overriden. It walks through every citation
# refering to the `entry` and create an anchor element containing reference id (refered
# as itemId) which link to the reference.
      updateReferences: (entry, itemId) ->
          for inTextRef in $("span.cite[data-bibkey~='#{entry.id}']")
            $(inTextRef).addClass("#{this.constructor.formatterName}-style-cite") # Style it according to the formatter
# Get the id elements
            beforeText = $(itemId).children('.before').html()
            afterText = $(itemId).children('.after').html()
            citationId = $(itemId).children('.content').html()
# Create the link to the reference
            citationLink = document.createElement('a')
            $(citationLink).attr('href', "##{entry.id}")
            $(citationLink).html(citationId)

# Create the text for the in-text citation. This is a little bit complicated due to
# the diference is there is only one reference or more in the same citation.
#
# So we start if there is no reference for the moment, the easiest case.
            if $(inTextRef).html() == ""
# So we add the reference, surrounded by same text as in the bibliography (generally,
# brackets or braces)
              $(inTextRef).append("#{beforeText}", citationLink, "#{afterText}")
            else
# If there is already a reference (so there is at least two references in the same
# citation).
# We remove the closing element, add the new id, and the closing element back
              $(inTextRef).html(
                $(inTextRef).html().slice(0,-1*afterText.length) + ", " + citationLink.outerHTML + afterText
              )

          return null

# This function doesn't have to be overriden too. It will create an object containing all
# required informations and elements to create the reference line for the entry.
      createItem: (entry) ->
# First, we seek for a reference schema depending on the entry type.
        schema = null
        if not @schemas[entry.type]? # If the entry type schema is not define, fallback on the default one
          schema = @schemas.default
        else
          schema = @schemas[entry.type]

        while typeof schema == 'string' # If the schema is a string, and not an object as expected, we handle the indirection
          schema = @schemas[schema]

# This is the returned item
        result = {
          html: "", # TODO: I don't remember what it is for... :(
          fields: [], # This is the list of the fields to display for the reference, in the right order
          elements: {} # This is an object, indexed by field name of element to add to the document
        }

        if schema?
# Whatever is the entry type, the reference will have an ID
# The ID content is generated by the `getId` function. It can be just an incremented
# counter, but also the name of the authors or whatever.
          result.fields.push('id')
          result.elements.id = @getId(entry)
          result.html = $(result.elements.id).html()

# Then we walk through the fields described in the schema. For each one, if it exists in
# the entry we create a span element composed of five parts.
          for field in schema
            if entry[field.field]?
              whole = document.createElement('span')
              $(whole).addClass("citation-item-#{field.field}") # Allow styling of fields

# First part, a whitespace before the field, if defined in the schema
              $(whole).append(field.beforeSpace) if field.beforeSpace?
# Second part, a prefix for the field with the class `.before`
              if field.before?
                before = document.createElement('span')
                $(before).addClass("before")
                $(before).html(field.before)
                $(whole).append(before)

# The third part, the actual field value, with the class `.content`
              content = document.createElement('span')
# The field is transformed by the `format`
              contentText = @format(
                field.field,
                if field.function? then field.function(entry) else entry[field.field] # TODO: What is the difference between field.function and format function
              )
              $(content).addClass("content")
              $(content).html(contentText)
              $(whole).append(content)

# Fourth part, a suffix styled with the `.after` class
              if field.after? and not contentText.endsWith(field.after)
                after = document.createElement('span')
                $(after).addClass("after")
                $(after).html(field.after)
                $(whole).append(after)
# And finally the suffix whitespace (to separate fields)
              $(whole).append(field.afterSpace) if field.afterSpace?

              result.fields.push(field.field)
              result.elements[field.field] = whole
              result.html += $(whole).html()
        else
# TODO : output as error
          console.log("Unrecognized entry type #{entry.type}.")

        return result

# The `sort` function reorder the list of entries to match the order of the bibliography.
# By default, `sort` return the same list, that is to say a list ordered in citation order.
      sort: (entries) -> entries

# The `getId` must be overriden by any implementing class. Given an entry, this function
# returns the index value (string). This can be a simple integer, or the surname of the first
# author or whatever you want.
      getId: (entry) ->
        throw "#{this} :: getId(entry) must be overrode"

# `format` function is a wrapper around the `formatFunctions` member. It will call the right
# function given the field to format and the actual value.
      format: (field, value) ->
        if @formatFunctions[field]?
          @formatFunctions[field](value)
        else
          ""

# Here is a list of default format functions. Most of them only return the value untouched.
      formatAddress:      (address) -> address
      formatAnnote:       (annote) -> annote
# An exception is the author field. Here, for a list of authors, the format function will return the
# firstname and the surname of the authors (in this order, separated by a space)
      formatAuthor:       (author) -> BibliographyStyleAbstract.formatAuthorFirstnameSurname(author)
      formatBookTitle:    (bookTitle) -> bookTitle
      formatChapter:      (chapter) -> chapter
      formatCrossRef:     (crossRef) -> crossRef
      formatEdition:      (edition) -> edition
      formatEditor:       (editor) -> BibliographyStyleAbstract.formatAuthorFirstnameSurname(editor)
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

# Here are some utility functions that can be used by sub-classes. For the moment thay can be
# used as the formatAuthors function.
# This first one returns the first letter of the firstname of the authors (F) followed by
# their surname (Surname)
# TODO: Add optional argument for the separator between F and Surname
      @formatAuthorFSurname: (authors) ->
        abbrvAuthors = (((author) ->
# We define a function which do the job for one author
          result = ""
# TODO: Remove this hard work and move it to the parser
          if author.firstname.search(/[- ]/) >= 0
# It's a composed name
            names = author.firstname.split(/[- ]/)
            for name in names
              result += "#{name.charAt(0)}. "
            result += author.lastname
          else
            result += "#{author.firstname.charAt(0)}. #{author.lastname}"
# The defined function is applied on every item in authors list to create a new list
          return result)(author) for author in authors)

# Here we handle the concatenation of every authors names.
        if abbrvAuthors.length == 1 # If there is only one author, that all.
          result = abbrvAuthors[0]
        else # If there is more authors
          result = abbrvAuthors[0..-2].join(', ') # Join first ones with a comma
          result += ", and #{abbrvAuthors[-1..][0]}" # Add the last one after an 'and'
        return result

# This format function does quiet the same than the previous one but returns Surname before
# firstname initials.
      @formatAuthorSurnameF: (authors) ->
# TODO: Remove this horrifying duplicated code!
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
          result = abbrvAuthors[0..-2].join(', ')
          result += ", and #{abbrvAuthors[-1..][0]}"
        return result

# As for both functions above, this function formats authors list returning Firstname and
# Surname.
      @formatAuthorFirstnameSurname: (authors) ->
        if authors.length == 1
          result = authors[0].name
        else
          result = (author.name for author in authors)[0..-2].join(', ')
          result += ", and #{authors[-1..][0].name}"
        return result
)

# Hum, well... Reading this file, it seems very complicated for not too much... There is many thing
# to rethink. I do a non-exhaustive list to remember me:
#   * Remove the html entry in the item object
#   * Reduce number of indirection between field value and formatting (field.function vs
#   formatFunctions)
#     -> Answer found reading the plain.coffee file. The field function allow a field to be
#     displayed even if not defined, fetching its value from other fields (e.g. author/editor)
#   * Do more and more generic utility functions (optional parameters)
#   * Avoid code duplication
#   * Move parsing code to the parser classes
