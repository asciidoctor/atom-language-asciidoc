describe 'Should tokenizes anchor macro when', ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage 'language-asciidoc'

    runs ->
      grammar = atom.grammars.grammarForScopeName 'source.asciidoc'

  # convenience function during development
  debug = (tokens) ->
    console.log(JSON.stringify tokens, null, ' ')

  it 'parses the grammar', ->
    expect(grammar).toBeDefined()
    expect(grammar.scopeName).toBe 'source.asciidoc'

  it 'simple anchor', ->
    {tokens} = grammar.tokenizeLine 'foo [[idname]] bar'
    expect(tokens).toHaveLength 5
    expect(tokens[0]).toEqual value: 'foo ', scopes: ['source.asciidoc']
    expect(tokens[1]).toEqual value: '[[', scopes: ['source.asciidoc', 'support.constant.asciidoc']
    expect(tokens[2]).toEqual value: 'idname', scopes: ['source.asciidoc', 'markup.blockid.asciidoc']
    expect(tokens[3]).toEqual value: ']]', scopes: ['source.asciidoc', 'support.constant.asciidoc']
    expect(tokens[4]).toEqual value: ' bar', scopes: ['source.asciidoc']

  it 'extends anchor', ->
    {tokens} = grammar.tokenizeLine 'foo [[idname,Reference Text]] bar'
    expect(tokens).toHaveLength 6
    expect(tokens[0]).toEqual value: 'foo ', scopes: ['source.asciidoc']
    expect(tokens[1]).toEqual value: '[[', scopes: ['source.asciidoc', 'support.constant.asciidoc']
    expect(tokens[2]).toEqual value: 'idname', scopes: ['source.asciidoc', 'markup.blockid.asciidoc']
    expect(tokens[3]).toEqual value: ',Reference Text', scopes: ['source.asciidoc']
    expect(tokens[4]).toEqual value: ']]', scopes: ['source.asciidoc', 'support.constant.asciidoc']
    expect(tokens[5]).toEqual value: ' bar', scopes: ['source.asciidoc']

  it 'simple anchor macro', ->
    {tokens} = grammar.tokenizeLine 'foo anchor:idname[] bar'
    expect(tokens).toHaveLength 6
    expect(tokens[0]).toEqual value: 'foo ', scopes: ['source.asciidoc']
    expect(tokens[1]).toEqual value: 'anchor:', scopes: ['source.asciidoc', 'support.constant.asciidoc']
    expect(tokens[2]).toEqual value: 'idname', scopes: ['source.asciidoc', 'markup.blockid.asciidoc']
    expect(tokens[3]).toEqual value: '[', scopes: ['source.asciidoc', 'support.constant.asciidoc']
    expect(tokens[4]).toEqual value: ']', scopes: ['source.asciidoc', 'support.constant.asciidoc']
    expect(tokens[5]).toEqual value: ' bar', scopes: ['source.asciidoc']

  it 'extends anchor macro', ->
    {tokens} = grammar.tokenizeLine 'foo anchor:idname[Reference Text] bar'
    expect(tokens).toHaveLength 7
    expect(tokens[0]).toEqual value: 'foo ', scopes: ['source.asciidoc']
    expect(tokens[1]).toEqual value: 'anchor:', scopes: ['source.asciidoc', 'support.constant.asciidoc']
    expect(tokens[2]).toEqual value: 'idname', scopes: ['source.asciidoc', 'markup.blockid.asciidoc']
    expect(tokens[3]).toEqual value: '[', scopes: ['source.asciidoc', 'support.constant.asciidoc']
    expect(tokens[4]).toEqual value: 'Reference Text', scopes: ['source.asciidoc', 'support.constant.asciidoc']
    expect(tokens[5]).toEqual value: ']', scopes: ['source.asciidoc', 'support.constant.asciidoc']
    expect(tokens[6]).toEqual value: ' bar', scopes: ['source.asciidoc']
