# Vinyl

**LaTeX is allergen! Use Vinyl!**

Vinyl is a HTML5/CSS3 framework based on [Bootstrap 4](http://v4-alpha.getbootstrap.com/) which allow you to create and write articles, thesis, poster, slides with an up-to-date, widely used and spread, technology.

See some examples on the [project website](https://alexisbrenon.github.io/Vinyl).

## Features

- [x] Bibliography management
 - [ ] plain
 - [ ] apa(like)
 - [ ] ieeetr
 - [ ] acm
 - [ ] unsrt
 - [ ] alpha
- [x] Figure and table auto-numbering
 - [x] Arab
 - [ ] Roman
 - [ ] Lettering

### Supported layouts

- [ ] ~~One column article~~
- [ ] ~~Two columns article~~
- [x] A0 poster
- [ ] A4 poster
- [x] ImpressJS slides
- [x] RevealJS slides

## Dependencies

### Jekyll

To easily maintain CSS, JS and HTML code, this repo follow a Jekyll project layout. So to easily compile and show examples you can run Jekyll or use the [jekyll/jekyll](https://hub.docker.com/r/jekyll/jekyll/) docker container.

### ImpressJS/RevealJS

To build impressive slideshows, Vinyl relies on well known frameworks, particulary ImpressJS and
RevealJS. Moreover, RevealJS come with many plugins. But don't be afraid, all of this is really easy
to install. For the Vinyl repo and don't forget to init/update sub-modules. Then all is fetched and
stored in assets/js/libs/. It's so easy!

## Documentation

For the moment there is no technical documentation for Vinyl, but you can find many informations
reading the code. Particulary:
 * `examples/vinyl/*.html` are some example for any (non-)supported layout with Vinyl.
   Unfortunately, they are very poorly documented for the moment.
 * `assets/js/{main.coffee,vinyl/**}` are all the JavaScript (actually CoffeeScript) files that
   make Vinyl work. We tried to document them as clearly as possible. Don't be afraid to ask if some
   points are not clear, and to add comments to improve the doc.
 * `assets/css/*` and `_sass` are the SCSS files used to generate the CSS. For the moment they're
   not documented, but I'm working on it. Actually, we can split this files in some parts:
    * `assets/css/*` are files read by Jekyll to generate CSS. Most of them only includes required
      SCSS files to create the final CSS files, one for each layout.
    * `_sass/{vinyl.scss,vinyl/**}` are common files for all the layouts. This is the part stolen
      from Bootstrap 4. So actually, read the Bootstrap documentation to learn all what you have to
      learn about it. The **only exception** is the `references` file and folder which contain
      styles for the bibliography and citations. Each new bibliography formatter comes with its own
      SCSS file placed in `references`.
    * `_sass/*` are specific folders for each layout. We (will) try to make them quiet similar to
      each other. For example, each one contains a `_variables.scss` file which define or override
      some default Vinyl variables; it must be the first file included, before including the main
      `vinyl` file. 

## Contribute
_Under construction_

Vinyl is a framework which have to be extended by its users. We tried to define a modular
architecture to allow anyone to build new parts easily.

### Bibliography generator

#### Parsers

TODO

#### Formatter

Vinyl comes with few formatter and supported reference type. You can start improving them defining
more entry type in the `schemas` class member, and adding more style rules in the
`_sass/vinyl/references/*` files.

Then you can of course add new formatter, following the example of the plain or apalike ones.

### Layouts

Adding a new layout is longer and generally harder than contributing to other parts. Open an issue
to discuss of it before to work hard on it. We're open to any proposition.

____

**Stay tuned, more to come!**
