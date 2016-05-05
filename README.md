# AsciiDoc Package for Atom [![Build Status](https://travis-ci.org/asciidoctor/atom-language-asciidoc.svg?branch=master)](https://travis-ci.org/asciidoctor/atom-language-asciidoc)

Adds syntax highlighting and snippets to AsciiDoc files. Supports [Asciidoctor](http://asciidoctor.org/)-specific features.

![](https://raw.github.com/wiki/asciidoctor/atom-language-asciidoc/writers-guide-screenshot.png)

The default file extensions for AsciiDoc files are _ad_, _asc_, _adoc_ and _asciidoc_.  To add a different file extension such as _.txt_, click on the *Settings* button in the package listing and then click the *View Code* button on the settings page.  Find the file named 'language-asciidoc.cson' under 'language-asciidoc > grammars'.  In the list of fileTypes, add a new line below "asciidoc" and type "txt". Then save the file and restart atom or press ctrl+alt+r to refresh the UI.  You should now see the new file type recognized by the atom-language-asciidoc package.

## Contributing

In the spirit of free software, _everyone_ is encouraged to help improve this project.

To contribute code, simply fork the project on GitHub, hack away and send a pull request with your proposed changes. We have a [dedicated guide](https://github.com/asciidoctor/atom-language-asciidoc/blob/master/CONTRIBUTING.adoc) to get you started.

Feel free to use the [issue tracker](https://github.com/asciidoctor/atom-language-asciidoc/issues) to provide feedback or suggestions in other ways.
