---
---

require.config({
  baseUrl: '/assets/js/vinyl'
  paths: {
    jquery: '../libs/jquery/jquery.min',
    bibtexParse: '../libs/bibtexParseJs/bibtexParse',
  }
  shim: {
    bibtexParse: {
      exports: 'bibtexParse'
    }
  }
});

require(['vinyl'], (vinyl) ->
  vinyl.run()
)
