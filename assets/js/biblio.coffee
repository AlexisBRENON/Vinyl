---
---

formatEntry = (bibEntry) -> bibEntry

loadBibFromBibTex = (bibFileName) ->
  bibliography = []
  console.log bibliography
  $.get({
    async: false,
    url: bibFileName,
    success: (data) ->
      console.log bibliography
      bibliography = bibtexParse.toJSON(data)
      console.log bibliography
  })
  console.log bibliography
  return bibliography


build_bibliography = ( jQuery ) ->
  bibList = $("#bibliography")[0]

  if bibList?
    inTextRefs = $("span.ref")
    bibFile = $(bibList).attr("data-bibliography-file")
    bibFileFormat = $(bibList).attr("data-bibliography-file-format")

    bibliography = {}
    switch bibFileFormat
      when "bibtex" then bibliography = loadBibFromBibTex(bibFile)
      when "bibjson" then bibliography = loadBibFromBibJson(bibFile)
      else alert("Unknown bibliography file format")

    if inTextRefs? and bibliography?
      for ref in inTextRefs
        refIndex = inTextRefs.index(ref)
        bibKey = $(ref).attr("data-bibkey")
        if bibliography[bibKey]
          newBibEntry = $(
            '<li>', {
              html: "<span class=\"ref\">[" + (refIndex+1) + "]</span>" + formatEntry(bibliography[bibKey])
            }
          )

          $(ref).html("[" + (refIndex+1) + "]")
          $(bibList).append(newBibEntry)
        else
          $(ref).remove()

$(document).ready(build_bibliography)
