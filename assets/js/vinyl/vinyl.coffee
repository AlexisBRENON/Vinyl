---
---

# Hello again. So you read the comments in the main CS file, and so you are here.
# This file is very short, isn't it?
#
# We start loading the Vinyl parts, like Bibliography and Auto-Numbering
# See specific files for more info. Yes, it's like a treasure hunting!
define(
  [
    './bibliography/bibliography',
    './autoNumbering/autoNumbering',
  ],
  (VinylBibliography, VinylAutoNumbering) ->
    console.log("@@ Vinyl @@ Initialization...") # Add some debug, it's useful
# Then we simply define a function called `run` which run all sub-parts of Vinyl.
    run = () ->
      VinylBibliography.run()
      VinylAutoNumbering.run()
    console.log("@@ Vinyl @@ Initialization: DONE")
# This funtion is wrapped in an JS object for best integration with RequireJS
    return {
      run: run
    }
)
