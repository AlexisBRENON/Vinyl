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
    revealjs: {
      deps: [
        'reveal.head',
        'reveal.classList',
# TODO : Markdown and Marked support with RequireJS
#        'reveal.markdown',
        'reveal.highlight',
        'reveal.zoom',
        'reveal.notes',
        'reveal.math',
      ]
      exports: 'Reveal'
    },
    'reveal.markdown': ['reveal.marked'],
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
        'revealjs'
      ], (Reveal) ->
        Reveal.initialize({
          width: 1280,
          height: 720,
          controls: false,
          progress: true,
          center: true,
          history: true,
          transition: 'slide', # none/fade/slide/convex/concave/zoom
          slideNumber: true,
          # Optional reveal.js plugins
          dependencies: [{
            src: '/assets/js/libs/revealjs/lib/js/classList.js',
            condition: ->
              return !document.body.classList
          },{
            src: '/assets/js/libs/revealjs/plugin/highlight/highlight.js',
            callback: ->
              hljs.initHighlightingOnLoad()
          },{
            src: '/assets/js/libs/revealjs/plugin/zoom-js/zoom.js',
            async: true
          },{
            src: '/assets/js/libs/revealjs/plugin/notes/notes.js',
            async: true
          },{
            src: '/assets/js/libs/revealjs/plugin/math/math.js',
            asyn: true
          }]
        })
      )
)

