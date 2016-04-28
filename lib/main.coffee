{CompositeDisposable} = require 'atom'
CSON = require 'season'
GrammarHelper = require './grammar-helper'
generator = require './code-block-generator'

module.exports =

  subscriptions: null

  activate: (state) ->
    @subscriptions = new CompositeDisposable()

    if atom.inDevMode()
      @subscriptions.add atom.commands.add 'atom-workspace', 'asciidoc-grammar:compile-grammar-and-reload': => @compileGrammar()

  compileGrammar: (debug) ->
    if atom.inDevMode()

      helper = new GrammarHelper('../grammars/repositories/', '../grammars/')

      rootGrammar = helper.readGrammarFile 'asciidoc-grammar.cson'
      rootGrammar.name = 'AsciiDoc'
      rootGrammar.scopeName = 'source.asciidoc'
      rootGrammar.fileTypes = [
        'ad'
        'asc'
        'adoc'
        'asciidoc'
      ]

      helper.appendPartialGrammarsDirectory rootGrammar, ['partials/', 'inlines/', 'blocks/']

      # Load languages list
      languages = helper.readGrammarFile 'languages.cson'

      # Add languages blocks for AsciiDoc
      codeAsciidocBlocks = generator.makeAsciidocBlocks languages
      rootGrammar.repository['source-asciidoctor'] = patterns: codeAsciidocBlocks

      # Add languages blocks for Markdown
      codeMarkdownBlocks = generator.makeMarkdownBlocks languages
      rootGrammar.repository['source-markdown'] = patterns: codeMarkdownBlocks

      if debug
        console.log CSON.stringify rootGrammar
      helper.writeGrammarFile rootGrammar, 'language-asciidoc.cson', do ->
        atom.commands.dispatch 'body', 'window:reload'

    deactivate: ->
      @subscriptions.dispose()
