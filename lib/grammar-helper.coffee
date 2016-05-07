{Directory} = require 'atom'
CSON = require 'season'
path = require 'path'

String::endsWith ?= (s) -> s is '' or @[-s.length..] is s

class GrammarHelper

  constructor: (@rootInputDirectory, @rootOutputDirectory) ->

  readGrammarFile: (file) ->
    filepath = path.join __dirname, @rootInputDirectory, file
    CSON.readFileSync filepath

  writeGrammarFile: (grammar, file) ->
    outputFilepath = path.join __dirname, @rootOutputDirectory, file
    CSON.writeFileSync outputFilepath, grammar

  appendPartialGrammars: (grammar, partialGrammarFiles) ->
    for grammarFile in partialGrammarFiles
      {key, patterns} = @readGrammarFile grammarFile
      if key? and patterns?
        grammar.repository[key] =
          patterns: patterns

  appendPartialGrammarsDirectory: (grammar, grammarDirectories) ->
    for directoryName in grammarDirectories
      directory = new Directory path.join(__dirname, @rootInputDirectory, directoryName)
      entries = directory.getEntriesSync()
      for entry in entries
        if entry.isFile() and entry.getBaseName().endsWith '.cson'
          {key, patterns} = CSON.readFileSync entry.path
          if key? and patterns?
            grammar.repository[key] =
              patterns: patterns

module.exports = GrammarHelper
