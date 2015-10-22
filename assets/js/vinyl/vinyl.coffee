---
---

define(
  "vinyl",
  [
    'jquery',
    'vinyl-bibliography',
    'vinyl-autoNumbering',
  ],
  ($, VinylBibliography, VinylAutoNumbering) ->
    console.log("@@ Vinyl @@ Initialization...")
    run = () ->
      VinylBibliography.createBibliography()
      VinylAutoNumbering.run()
    console.log("@@ Vinyl @@ Initialization: DONE")
    return {
      run: run
    }
)
