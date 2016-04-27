{CompositeDisposable} = require 'atom'
CSON = require 'season'
GrammarHelper = require './grammar-helper'

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

      partialGrammars = [
        'comment-grammar.cson'
        'list-grammar.cson'
        'titles-grammar.cson'
        'various-grammar.cson'
        'inlines/inlines-grammar.cson'
        'blocks/admonition-grammar.cson'
        'blocks/quote-grammar.cson'
        'blocks/table-grammar.cson'
        'blocks/various-blocks-grammar.cson'
        'blocks/source-asciidoc-grammar.cson'
        'blocks/source-markdown-grammar.cson'
      ]
      helper.appendPartialGrammars rootGrammar, partialGrammars

      if debug
        console.log CSON.stringify rootGrammar
      helper.writeGrammarFile rootGrammar, 'language-asciidoc.cson', do ->
        atom.commands.dispatch 'body', 'window:reload'

    deactivate: ->
      @subscriptions.dispose()
