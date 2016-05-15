# AsciiDoc Language Package for Atom

[![Atom Package](https://img.shields.io/apm/v/language-asciidoc.svg)](https://atom.io/packages/language-asciidoc)
[![Atom Package Downloads](https://img.shields.io/apm/dm/language-asciidoc.svg)](https://atom.io/packages/language-asciidoc)
[![Build Status (Linux)](https://travis-ci.org/asciidoctor/atom-language-asciidoc.svg?branch=master)](https://travis-ci.org/asciidoctor/atom-language-asciidoc)
[![Build Status (Windows)](https://ci.appveyor.com/api/projects/status/midrj94vvwvynqay?svg=true)](https://ci.appveyor.com/project/asciidoctor/atom-language-asciidoc)
[![MIT License](http://img.shields.io/badge/license-MIT-blue.svg?style=flat)](https://github.com/asciidoctor/atom-language-asciidoc/blob/master/LICENSE.md)

Adds syntax highlighting and snippets to AsciiDoc files. Supports [Asciidoctor](http://asciidoctor.org/)-specific features.

![](https://raw.github.com/wiki/asciidoctor/atom-language-asciidoc/writers-guide-screenshot.png)

**NOTE:** This package recognizes the modern AsciiDoc syntax endorsed by Asciidoctor. It does not support the legacy AsciiDoc syntax permitted by Asciidoctor with [compat mode](http://asciidoctor.org/docs/migration/#compat-mode) enabled or by AsciiDoc Python. Additionally, two-line section titles are _not recognized_ by this package since they confuse both the language highlighter and the writer.

## File extension support

The default file extensions for AsciiDoc files are _ad_, _asc_, _adoc_, _asciidoc_, and _asciidoc.txt_
Changing the file extension to _asciidoc.txt_ is a recommended solution to remain compatibile with _.txt_ based tooling, whilst having a distinct filename related to the AsciiDoc language.
To add a different file extension, such at _.txt_, customize your Atom configuration:

Open the Atom configuration:
* Menu > _Edit_ > _Config.._
* 'Application: open your config' via the Command Palette
* Edit `~/.atom/config.cson`

Add a custom file type support:
```coffee
  core:
    ...
    customFileTypes:
      "source.asciidoc": [
          "foo" # all files with `.foo` extension (ex: `documentation.foo`)
          "foobar.txt" # all files with `.foobar.txt` extension  (ex `documentation.foobar.txt`)
      ]
    ...
```

Then save the configuration file and restart Atom or press <kbd>ctrl + alt + r</kbd> to refresh the UI.  You should now see the new file type recognized by the atom-language-asciidoc package.

## Contributing

In the spirit of free software, _everyone_ is encouraged to help improve this project.

To contribute code, simply fork the project on GitHub, hack away and send a pull request with your proposed changes. We have a [dedicated guide](https://github.com/asciidoctor/atom-language-asciidoc/blob/master/CONTRIBUTING.adoc) to get you started.

Feel free to use the [issue tracker](https://github.com/asciidoctor/atom-language-asciidoc/issues) to provide feedback or suggestions in other ways.
