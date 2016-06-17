---
---

# This is one of the most important file of the parser folder (see also parserFactory, the other
# most important file).
# This file will define an abstract base class that any parse will have to derive from and
# implement. It defines the required functions that will be called by the files using any parser.

define(
  [], () ->
    console.log("@@ Vinyl::Bibliography::Parser::Abstract @@ Initialisation...")
    class BibliographyParserAbstract
      constructor: ->

# Any class deriving from this abstract one will have to implement the `parse(file)` function which
# will read the file whose path is given in argument and then parse it to return a JS object
# containing all the bibligraphy entries.
      parse: (file) ->
        throw "Not Implemented In Abstract Class."

# Return a JSON object representing a name with fields: name, firstname, middlename, lastname, suffix.
# This function can parse different name format :
#   Jean de La Fontaine
#   de La Fontaine, Jean
#   de La Fontaine, Jr., Jean
# Feel free to add more !
      parseName: (name) ->
        splitted_name = name.split(', ')
        switch splitted_name.length
          when 1 then return @parseFMLName(splitted_name)
          when 2 then return @parseMLFName(splitted_name)
          when 3 then return @parseMLSFName(splitted_name)
          else @parseFMLName(splitted_name)

      # Parse Jean de la Fontaine
      parseFMLName: (splitted_name) ->
        splitted_name = splitted_name[0].split(' ')
        # Lastname cannot be empty
        lastname = []
        firstname = []
        middlename = []
        braceGoto = 'last'
        lowerGoto = 'von'
        upperGoto = 'first'
        for name, i in splitted_name[0..-2]
          first_char = name.charAt(0)
          if first_char == "{"
            if braceGoto == 'last'
              lastname.push(name.replace(/^{|}$/gm, ''))
            else if braceGoto == 'first'
              firstname.push(name.replace(/^{|}$/gm, ''))
          else if first_char == first_char.toUpperCase()
            if upperGoto == 'first'
              braceGoto = "first"
              firstname.push(name)
            else if upperGoto == "last"
              lastname.push(name)
            else if upperGoto == "von"
              nextFirstChar = splitted_name[i+1].charAt(0)
              if nextFirstChar == nextFirstChar.toUpperCase()
                upperGoto = "last"
                lastname.push(name)
              else
                middlename.push(name)
          else if first_char == first_char.toLowerCase()
            middlename.push(name)
            upperGoto = "von"

        lastname.push(splitted_name[-1..][0])

        firstname = if firstname.length > 0 then firstname.join(' ') else null
        lastname = if lastname.length > 0 then lastname.join(' ') else null
        middlename = if middlename.length > 0 then middlename.join(' ') else null
        name = if middlename? then middlename + " " else ""
        name += if lastname? then lastname else ""
        name += if firstname? then ", " + firstname else ""
        return {
          name: name
          firstname: firstname,
          middlename: middlename,
          lastname: lastname,
          suffix: null
        }
  
      # parse 'de La Fontaine, Jean'
      parseMLFName: (splitted_name) ->
        firstname = splitted_name[1].split(' ')
        lastname = []
        middlename = []

        splitted_name = splitted_name[0].split(' ')
        lastname.push(splitted_name[-1..][0])

        for name in splitted_name.reverse()[1..]
          first_char = name.charAt(0)
          if first_char == first_char.toUpperCase()
            if middlename.length > 0
              middlename.splice(0, 0, name)
            else
              lastname.splice(0, 0, name)
          else
            middlename.splice(0, 0, name)

        firstname = if firstname.length > 0 then firstname.join(' ') else null
        lastname = if lastname.length > 0 then lastname.join(' ') else null
        middlename = if middlename.length > 0 then middlename.join(' ') else null
        name = if middlename? then middlename + " " else ""
        name += if lastname? then lastname else ""
        name += if firstname? then ", " + firstname else ""
        return {
          name: name
          firstname: firstname,
          middlename: middlename,
          lastname: lastname,
          suffix: null
        }

      parseMLSFName: (splitted_name) ->
        result = @parseMLFName([splitted_name[0], splitted_name[2]])
        result.suffix = splitted_name[1]
        result.name = splitted_name.join(', ')
        return result



    console.log("@@ Vinyl::Bibliography::Parser::Abstract @@ Initialisation...")
    return BibliographyParserAbstract
)
