GrammarHelper = require '../lib/grammar-helper'

describe 'Grammar helper', ->

  helper = new GrammarHelper('../spec/fixtures/grammars/', '../spec/output/')

  it 'should create a grammar object when read a grammar file', ->
    fileContent = helper.readGrammarFile 'sample01.cson'

    expect(fileContent).toEqualJson key: 'test', patterns: ['foo', 'bar']

  it 'should append file content to existing grammar when read a partial grammar file', ->
    grammar =
      repository: {}

    partialGrammarFiles = [
      'sample01.cson'
    ]

    helper.appendPartialGrammars grammar, partialGrammarFiles

    expect(grammar).toEqualJson repository: test: patterns: ['foo', 'bar']
