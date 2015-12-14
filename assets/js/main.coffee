---
---

require.config({
  paths: {
    jquery: 'libs/jquery/jquery.min',
    bibtexParse: 'libs/bibtexParseJs/bibtexParse',
    impressjs: 'libs/impress.js/js/impress',
    reveal: 'libs/revealjs/js/reveal',
    'reveal.head': 'libs/revealjs/lib/js/head.min',
    'reveal.classList': 'libs/revealjs/lib/js/classList',
    'reveal.markdown': 'libs/revealjs/plugin/markdown/markdown',
    'reveal.marked': 'libs/revealjs/plugin/markdown/marked',
    'reveal.highlight': 'libs/revealjs/plugin/highlight/highlight',
    'reveal.zoom': 'libs/revealjs/plugin/zoom-js/zoom',
    'reveal.notes': 'libs/revealjs/plugin/notes/notes',
    'reveal.math': 'libs/revealjs/plugin/math/math',
  }
  shim: {
    bibtexParse: {
      exports: 'bibtexParse'
    },
    impressjs: {
      exports: 'impress'
    },
    reveal: {
      deps: [
        'reveal.head',
      ]
      exports: 'Reveal'
    },
    'reveal.classList' : ['reveal'],
    'reveal.zoom' : ['reveal'],
    'reveal.notes' : ['reveal'],
    'reveal.math' : ['reveal'],
    'reveal.markdown': ['reveal', 'reveal.marked'],
    'reveal.highlight': {
      deps: ['reveal']
      exports: 'hljs'
    }
  }
})

require(['vinyl/vinyl'], (vinyl) ->
  vinyl.run()
)

require(
  [
    'jquery',
    'require',
  ], ($, require) ->
    if $('#impress').length > 0
      require([
        'impressjs'
      ], (impressJs) ->
        impressJs().init()
      )
)

require(
  [
    'jquery',
    'require'
  ], ($, require) ->
    if $('.reveal').length > 0
      require([
        'reveal',
        'reveal.marked'
        'reveal.highlight',
        'reveal.classList',
        'reveal.zoom',
        'reveal.notes',
        'reveal.math',
      ], (Reveal, marked, hljs) ->
        this.marked = marked
        require(
          [
            'reveal.markdown'
          ], ->
            Reveal.initialize({
              width: 1280,
              height: 720,
              controls: false,
              progress: true,
              center: true,
              history: true,
              transition: 'slide', # none/fade/slide/convex/concave/zoom
              slideNumber: true,

              math: {
                mathjax: '/assets/js/libs/MathJax/MathJax.js'
              }
            })
            hljs.initHighlighting()
        )
      )
)

