---
---

# Here is the configuration part of RequireJS.
# You don't know requireJS? It's a JS framework which allow you to don't overload your HTML code
# with JS inclusion. Moreover, it allows asynchronous loading to reduce loading time and so on. See
# the doc for more info.
# Let's detail more the config object.

require.config({
  baseUrl: '{{ site.url }}/assets/',
  paths: { # Here, we assign an easy to remember name to some JS files.
    vinyl: 'js/vinyl/', # The Vinyl entry point
    jquery: 'libs/jquery/dist/jquery.min',
    bibtexParse: 'libs/bibtexParseJs/bibtexParse', # A library to parse BibTex file. It has some drawback but I didn't found a better one
    impressjs: 'libs/impress.js/js/impress', # The ImpressJS framework
    reveal: 'libs/reveal.js/js/reveal', # The RevealJS framework
    # Reveal comes with many libs and plugins to make your life easier
    'reveal.highlight': 'libs/reveal.js/plugin/highlight/highlight', # Syntax highlighting of code blocks (amazing!)
    'reveal.head': 'libs/headjs/dist/1.0.0/head.min', # This is a cryptic dependancy
    'reveal.classList': 'libs/reveal.js/lib/js/classList', # Cross-browser support of the classlist feature
    'reveal.markdown': 'libs/reveal.js/plugin/markdown/markdown', # Markdown support for slides design
    'reveal.marked': 'libs/reveal.js/plugin/markdown/marked', # Markdown parser (dependancy of markdown plugin)
    'reveal.zoom': 'libs/reveal.js/plugin/zoom-js/zoom', # Allow you to zoom-in or out in your slides
    'reveal.notes': 'libs/reveal.js/plugin/notes/notes', # Plugin to enable presenter notes
    'reveal.math': 'libs/reveal.js/plugin/math/math', # TeX equation rendering

    # Come back to generic components
    hljs: 'libs/highlightjs/highlight.pack', # Syntax highlighting of code blocks (amazing!)
    mathjax: 'libs/MathJax/MathJax.js?config=TeX-MML-AM_CHTML', # Mathematic equations rendering
    morpheus: 'libs/svg-morpheus/compile/minified/svg-morpheus'
  }
# Not all libs support the RequireJS loading scheme. For these old ones, you have to say to
# Require which object is intended to be used by dependent modules
  shim: {
    bibtexParse: {
      exports: 'bibtexParse'
    },
    impressjs: {
      exports: 'impress'
    },
    # Reveal plugins must be loaded after the main reveal file
    'reveal.classList' : ['reveal'],
    'reveal.zoom' : ['reveal'],
    'reveal.notes' : ['reveal'],
    'reveal.math' : ['reveal'],
    'reveal.markdown': ['reveal'],
    'reveal.highlight': {
      dependancies: ['reveal'],
      exports: 'hljs'
    }
  }
})

# Wow, what a long configuration part !
