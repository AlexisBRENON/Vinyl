---
---

define(
  [
    './bibliography/bibliography',
    './autoNumbering/autoNumbering',
  ],
  (VinylBibliography, VinylAutoNumbering) ->
    console.log("@@ Vinyl @@ Initialization...")
    run = () ->
      VinylBibliography.run()
      VinylAutoNumbering.run()
    console.log("@@ Vinyl @@ Initialization: DONE")
    return {
      run: run
    }
)
