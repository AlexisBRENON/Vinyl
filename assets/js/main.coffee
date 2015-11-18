---
---

require.config({
  paths: {
    jquery: 'libs/jquery/jquery.min',
    bibtexParse: 'libs/bibtexParseJs/bibtexParse',
    impressjs: 'libs/impress.js/js/impress',
  }
  shim: {
    bibtexParse: {
      exports: 'bibtexParse'
    }
    impressjs: {
      exports: 'impress'
    }
  }
})

require(['vinyl/vinyl'], (vinyl) ->
  vinyl.run()
)

require(
  [
    'jquery',
    'impressjs'
  ], ($, impressJs) ->
    if $('#impress').length > 0
      impressJs().init()
)

