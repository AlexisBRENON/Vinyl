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
              'reveal.highlight',
              'reveal.classList',
              'reveal.zoom',
              'reveal.notes',
              'reveal.math',
            ],
            (Reveal, hljs) ->
              # Initialize the Reveal presentation giving the configuration (see the project page to
              # see all available options)
              height = parseFloat($(':root').css('line-height'))*20.0
              width = height * 16/9
              Reveal.initialize({
                width: width,
                height: height,
                maxScale: 10,
                minScale: 0.1,
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

