---
---

define(
  "vinyl",
  ['jquery', 'vinyl-bibliography'],
  ($, VinylBibliography) ->
    console.log("@@ Vinyl @@ Initialization...")
    run = () ->
      VinylBibliography.createBibliography()
    console.log("@@ Vinyl @@ Initialization: DONE")
    return {
      run: run
    }
)
