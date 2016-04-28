GrammarHelper = require '../lib/grammar-helper'

describe "Grammar helper", ->

  helper = null

  beforeEach ->
    helper = new GrammarHelper('../spec/fixtures/grammars/', '../spec/output/')

  it 'should create a grammar object when read a grammar file', ->
    fileContent = helper.readGrammarFile 'sample01.cson'
    expect(fileContent.key).toEqual 'test'
    expect(fileContent.patterns).toHaveLength 2
    expect(fileContent.patterns[0]).toEqual 'foo'
    expect(fileContent.patterns[1]).toEqual 'bar'
