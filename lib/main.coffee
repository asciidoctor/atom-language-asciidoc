{CompositeDisposable} = require 'atom'
CSON = require 'season'
GrammarHelper = require './grammar-helper'
generator = require './code-block-generator'
path = require 'path'

module.exports =

  config:
    liveReload:
      title: '[Only on Developer Mode] Grammars live reload'
      type: 'boolean'
      default: false

  subscriptions: null
  liveReloadSubscriptions: null

  activate: (state) ->
    return unless atom.inDevMode() and not atom.inSpecMode()

    @subscriptions = new CompositeDisposable

    @helper = new GrammarHelper '../grammars/repositories/', '../grammars/'

    # Add actions in Command Palette
    @subscriptions.add atom.commands.add 'atom-workspace',
      'asciidoc-grammar:compile-grammar-and-reload': => @compileGrammar()
      'asciidoc-grammar:toggle-live-reload': ->
        keyPath = 'language-asciidoc.liveReload'
        atom.config.set(keyPath, not atom.config.get(keyPath))

    # Calls immediately and every time the value is changed
    @subscriptions.add atom.config.observe 'language-asciidoc.liveReload', (newValue) =>
      return unless atom.inDevMode()
      if newValue
        @compileGrammar()
        @liveReloadSubscriptions = new CompositeDisposable
        @startliveReload()
      else
        @liveReloadSubscriptions?.dispose()

  startliveReload: ->
    return unless atom.inDevMode() and not atom.inSpecMode() and atom.config.get 'language-asciidoc.liveReload'

    @liveReloadSubscriptions.add atom.workspace.observeTextEditors (editor) =>
      if path.extname(editor.getTitle()) is '.cson'
        @liveReloadSubscriptions.add editor.buffer.onDidSave =>
          @compileGrammar()

  compileGrammar: (debug) ->
    return unless atom.inDevMode() and not atom.inSpecMode()

    rootGrammar = @helper.readGrammarFile 'asciidoc-grammar.cson'
    rootGrammar.name = 'AsciiDoc'
    rootGrammar.scopeName = 'source.asciidoc'
    rootGrammar.fileTypes = [
      'ad'
      'asc'
      'adoc'
      'asciidoc'
      'adoc.txt'
    ]

    @helper.appendPartialGrammarsDirectory rootGrammar, ['partials/', 'inlines/', 'blocks/', 'tables/']

    # Load languages list
    languages = @helper.readGrammarFile 'languages.cson'

    # Add languages blocks for AsciiDoc
    codeAsciidocBlocks = generator.makeAsciidocBlocks languages
    rootGrammar.repository['source-asciidoctor'] = patterns: codeAsciidocBlocks

    # Add languages blocks for Markdown
    codeMarkdownBlocks = generator.makeMarkdownBlocks languages
    rootGrammar.repository['source-markdown'] = patterns: codeMarkdownBlocks

    if debug
      console.log CSON.stringify rootGrammar
    @helper.writeGrammarFile rootGrammar, 'language-asciidoc.cson'
    @reload()

  reload: ->
    # Remove grammars
    atom.grammars.removeGrammarForScopeName 'source.asciidoc'
    atom.grammars.removeGrammarForScopeName 'source.asciidoc.properties'

    # Remove loaded package (Hack force reload)
    delete atom.packages.loadedPackages['language-asciidoc']

    # Load package
    updatedPackage = atom.packages.loadPackage 'language-asciidoc'
    updatedPackage.loadGrammarsSync()

    # Reload grammars for each editor
    atom.workspace.getTextEditors().forEach (editor) ->
      if editor.getGrammar().packageName is 'language-asciidoc'
        editor.reloadGrammar()

    console.log 'AsciiDoc grammars reloaded'

    deactivate: ->
      @liveReloadSubscriptions?.dispose()
      @subscriptions.dispose()
