---
---

require.config({
  paths: {
    jquery: 'libs/jquery/jquery.min',
    bibtexParse: 'libs/bibtexParseJs/bibtexParse',
    impressjs: 'libs/impress.js/js/impress',
    revealjs: 'libs/revealjs/js/reveal',
    head: 'libs/revealjs/lib/js/head.min'
  }
  shim: {
    bibtexParse: {
      exports: 'bibtexParse'
    },
    impressjs: {
      exports: 'impress'
    },
    revealjs: {
      exports: 'Reveal'
    },
    head: {
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
    'require',
    'head'
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
            src: '/assets/js/libs/revealjs/plugin/markdown/marked.js',
            condition: ->
              return !!document.querySelector('[data-markdown]')
          },{
            src: '/assets/js/libs/revealjs/plugin/markdown/markdown.js',
            condition: ->
              return !!document.querySelector('[data-markdown]')
          },{
            src: '/assets/js/libs/revealjs/plugin/highlight/highlight.js',
            async: true,
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

