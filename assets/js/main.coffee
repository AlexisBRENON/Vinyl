---
---

# Welcome in the main Vinyl CoffeeScript file.
# If you don't know CoffeeScript, don't be affraid, it's as easy (if not easier) than JS. It's a
# language which is compiled to JS. Learn more on the official website.
#
# Let's see what you do here.
#
# First, did you notice the two lines of three dashes at the top ? They are useless for our final
# JS. It's used by Jekyll and required to let it compile our file.
#
# Then you have this big comment block. Nothing fancy here, it's just comments.

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
    reveal: {
      exports: 'Reveal'
      deps: [
        'reveal.head',
      ]
    },
    # Reveal plugins must be loaded after the main reveal file
    'reveal.classList' : ['reveal'],
    'reveal.zoom' : ['reveal'],
    'reveal.notes' : ['reveal'],
    'reveal.math' : ['reveal'],
    'reveal.markdown': ['reveal', 'reveal.marked'],
    'reveal.highlight': {
      dependancies: ['reveal'],
      exports: 'hljs'
    },
    'mathjax': {
      exports: 'MathJax'
    }
  }
})

# Wow, what a long configuration part !
# Until here, nothing has been done. Now, you'll load modules and call them to do their jobs.

# First step. Vinyl stuffs. This include:
#   * bibliography generation
#   * title/figure/table auto-numbering
# See vinyl/vinyl.coffee for more info.

require(
  [
    'vinyl/vinyl',
  ],
  (vinyl) ->
    # Just call the main vinyl function.
    # Perhaps, Vinyl can be improved allowing more configuration, and interaction. But it cannot be
    # perfect on the first try.
    vinyl.run()

    # Now that the Vinyl work is done let's do specific job depending on document type.
    require(
      [
        'jquery',
      ],
      ($) ->

##########################################################################
# Impress JS

        if $('#impress').length > 0
          require(
            [
              'impressjs'
            ],
            (impressJs) ->
              impressJs().init()
          )

##########################################################################
# Reveal JS

        else if $('.reveal').length > 0
          require(
            [
              'reveal',
              'reveal.marked',
              'reveal.highlight',
              'reveal.classList',
              'reveal.zoom',
              'reveal.notes',
              'reveal.math',
            ],
            (Reveal, marked, hljs) ->
              # TODO: clean this
              # DIRTY workaround required to let the markdown plugin load
              this.marked = marked
              require(
                [
                  'reveal.markdown'
                ], ->
                  # Initialize the Reveal presentation giving the configuration (see the project page to
                  # see all available options)
                  height = parseFloat($(':root').css('line-height'))*20.0
                  width = height*16/9
                  Reveal.initialize({
                    width: width,
                    height: height,
                    controls: false, # Remove the mouse controls which are not so beautiful
                    progress: true, # Add a progress bar
                    center: true, # Slide content will be vertically and horizontally centered
                    history: true, # A press on backspace will go back to previous slides
                    transition: 'slide', # none/fade/slide/convex/concave/zoom
                    backgroundTransition: 'slide', # none/fade/slide/convex/concave/zoom
                    slideNumber: true, # Display slide number in bottom right corner
                    math: {
                      mathjax: '{{ site.url }}/assets/libs/MathJax/MathJax.js' # Use an offline version of MathJax
                    }
                  })
                  hljs.initHighlighting() # Apply highlighting
              )
            )

##########################################################################
# Generic cases

        else
          # Add syntax highlighting for code blocks
          require(
            [
              'hljs',
            ],
            (hljs) ->
              hljs.initHighlighting()
          )

          # Load MathJax to render TeX equations as pure HTML/CSS
          require(
            [
              'mathjax',
            ],
            (MathJax) ->
              # Nothing to do, just load MathJax
          )
    )
)

##########################################################################
# That's it. All is done. Your document is SOOOO good !
# Ask me questions on Twitter (@AlexisBRENON) or by e-mail (brenon.alexis+vinyl@gmail.com)
# You can also, open issues, fork, and pull request on GitHub.

