CSON = require 'season'
path = require 'path'

class GrammarHelper

  constructor: (@rootInputDirectory, @rootOutputDirectory) ->

  readGrammarFile: (file) ->
    filepath = path.join __dirname, @rootInputDirectory, file
    CSON.readFileSync filepath

  writeGrammarFile: (grammar, file, cal) ->
    outputFilepath = path.join __dirname,  @rootOutputDirectory, file
    CSON.writeFileSync outputFilepath, grammar

  appendPartialGrammars: (grammar, partialGrammarFiles) ->
    for grammarFile in partialGrammarFiles
      {key, patterns} = @readGrammarFile grammarFile
      if key? and patterns?
        grammar.repository[key] =
          patterns: patterns

module.exports = GrammarHelper
