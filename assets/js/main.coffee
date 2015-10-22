---
---

require.config({
  baseUrl: '/assets/js/vinyl'
  paths: {
    jquery: '/assets/js/libs/jquery/jquery.min',
    bibtexParse: '/assets/js/libs/bibtexParseJs/bibtexParse',
    'vinyl-bibliography': 'bibliography/bibliography'
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
