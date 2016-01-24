---
---

# Welcome in the main Vinyl CoffeeScript file.
# If you don't know CoffeeScript, don't be affraid, it's as easy (if not easier) than JS. It's a
# language which is compiled to JS. Learn more on the official website.
#
# Let's what you do here.
#
# First, did you notice the two lines of three dashes at the top ? They are useless for our final
# JS. It's used by Jekyll and required to let it compile our file.
#
# Then you have this big comment block. Nothing fancy here, it's just comments.

# Here is the configuration part of RequireJS.
# You don't know requireJS. It's a JS framework which allow you to don't overload your HTML code
# with JS inclusion. Moreover, it allows asynchronous loading to reduce loading time and so on. See
# the doc for more info.
# Let's detail more the config object.
require.config({
# Here, we assign an easy to remember name to some JS files.
  paths: {
# The good old one, minified
    jquery: 'libs/jquery/jquery.min',
# A library to parse BibTex file. It has some drawback but I didn't found a better one
    bibtexParse: 'libs/bibtexParseJs/bibtexParse',
# A very customizable (and hard to use) framework to do some presentations
    impressjs: 'libs/impress.js/js/impress',
# A less customizable (but very easy to use) framework to do some presentations
    reveal: 'libs/revealjs/js/reveal',
# Reveal comes with many libs and plugins to make your life easier
# TODO: Use another highlightjs implementation for generic cases
    'highlightjs': 'libs/revealjs/plugin/highlight/highlight', # Syntax highlight of code blocks (amazing!)
    'reveal.highlight': 'libs/revealjs/plugin/highlight/highlight', # Syntax highlight of code blocks (amazing!)
    'reveal.head': 'libs/revealjs/lib/js/head.min', # This is a cryptic dependancy
    'reveal.classList': 'libs/revealjs/lib/js/classList', # Cross-browser support of the classlist feature
    'reveal.markdown': 'libs/revealjs/plugin/markdown/markdown', # Markdown support for slides design
    'reveal.marked': 'libs/revealjs/plugin/markdown/marked', # Markdown parser (dependancy of markdown plugin)
    'reveal.zoom': 'libs/revealjs/plugin/zoom-js/zoom', # Allow you to zoom-in or out in your slides
    'reveal.notes': 'libs/revealjs/plugin/notes/notes', # Plugin to enable presenter notes
    'reveal.math': 'libs/revealjs/plugin/math/math', # TeX equation rendering
    mathjax: '../../node_modules/mathjax/MathJax.js?config=TeX-MML-AM_CHTML'
  }
# Not all libs support the RequireJS loading scheme. For these old ones, you have to say to
# Require which object is intended to be used by dependant modules
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
# Most of the Reveal plugins don't export anything
# But they must to be loaded after the Reveal module
    'reveal.classList' : ['reveal'],
    'reveal.zoom' : ['reveal'],
    'reveal.notes' : ['reveal'],
    'reveal.math' : ['reveal'],
    'reveal.markdown': ['reveal', 'reveal.marked'],
    'reveal.highlight': {
      dependancies: ['reveal'],
      exports: 'hljs'
    },
    'highlightjs': {
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

# RequireJS will load the vinyl/vinyl.js file and bind it's returned object to the `vinyl` variable
require(['vinyl/vinyl'], (vinyl) ->
# Just call the main vinyl function.
# Perhaps, Vinyl can be improved allowing more configuration, and interaction. But it cannot be
# perfect on the first try.
  vinyl.run()

# Now that the Vinyl work is done let's do specific job depending on document type.

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
            Reveal.initialize({
              width: 1280,
              height: 720,
              controls: false, # Remove the mouse controls which are not so beautiful
              progress: true, # Add a progress bar
              center: true, # Slide content will be vertically and horizontally centered
              history: true, # A press on backspace will go back to previous slides
              transition: 'slide', # none/fade/slide/convex/concave/zoom
              slideNumber: true, # Display slide number in bottom right corner
              math: {
                mathjax: '/assets/js/libs/MathJax/MathJax.js' # Use an offline version of MathJax
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
        'highlightjs',
      ],
      (hljs) ->
        hljs.initHighlighting()
    )

# Load MathJax to render LaTeX equations
    require(
      [
        'mathjax',
      ],
      (MathJax) ->
    )
)

##########################################################################
# That's it. All is done. Your document is SOOOO good !
# Ask me questions on Twitter (@AlexisBRENON) or by e-mail (brenon.alexis+vinyl@gmail.com)
# You can also, open issues, fork, and pull request on GitHub.

