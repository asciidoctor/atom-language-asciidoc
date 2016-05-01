describe 'Should tokenizes callout list item when', ->
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

  it 'contains simple callout', ->
    {tokens} = grammar.tokenizeLine '<1> foobar'
    expect(tokens).toHaveLength 5
    expect(tokens[0]).toEqual value: '<', scopes: ['source.asciidoc', 'callout.asciidoc', 'constant.other.symbol.asciidoc']
    expect(tokens[1]).toEqual value: '1', scopes: ['source.asciidoc', 'callout.asciidoc', 'constant.numeric.asciidoc']
    expect(tokens[2]).toEqual value: '>', scopes: ['source.asciidoc', 'callout.asciidoc', 'constant.other.symbol.asciidoc']
    expect(tokens[3]).toEqual value: ' ', scopes: ['source.asciidoc', 'callout.asciidoc']
    expect(tokens[4]).toEqual value: 'foobar', scopes: ['source.asciidoc', 'callout.asciidoc']

  it 'contains callout mixed with inline element', ->
    {tokens} = grammar.tokenizeLine '<1> *Grammars* _definition_'
    expect(tokens).toHaveLength 9
    expect(tokens[0]).toEqual value: '<', scopes: ['source.asciidoc', 'callout.asciidoc', 'constant.other.symbol.asciidoc']
    expect(tokens[1]).toEqual value: '1', scopes: ['source.asciidoc', 'callout.asciidoc', 'constant.numeric.asciidoc']
    expect(tokens[2]).toEqual value: '>', scopes: ['source.asciidoc', 'callout.asciidoc', 'constant.other.symbol.asciidoc']
    expect(tokens[3]).toEqual value: ' ', scopes: ['source.asciidoc', 'callout.asciidoc']
    expect(tokens[4]).toEqual value: '*', scopes: ['source.asciidoc', 'callout.asciidoc', 'markup.bold.constrained.asciidoc', 'support.constant.asciidoc']
    expect(tokens[5]).toEqual value: 'Grammars', scopes: ['source.asciidoc', 'callout.asciidoc', 'markup.bold.constrained.asciidoc']
    expect(tokens[6]).toEqual value: '*', scopes: ['source.asciidoc', 'callout.asciidoc', 'markup.bold.constrained.asciidoc', 'support.constant.asciidoc']
    expect(tokens[7]).toEqual value: ' ', scopes: ['source.asciidoc', 'callout.asciidoc']
    expect(tokens[8]).toEqual value: '_definition_', scopes: ['source.asciidoc', 'callout.asciidoc', 'markup.italic.asciidoc']

  it 'contains misplaced callout (invalid context)', ->
    {tokens} = grammar.tokenizeLine '   <1> foobar'
    expect(tokens).toHaveLength 1
    expect(tokens[0]).toEqual value: '   <1> foobar', scopes: ['source.asciidoc']

  it 'contains multiple callout', ->
    tokens = grammar.tokenizeLines '''
                                      <1> foobar
                                      <2> fiibir
                                      <3> feeber
                                      '''
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toHaveLength 5
    expect(tokens[0][0]).toEqual value: '<', scopes: ['source.asciidoc', 'callout.asciidoc', 'constant.other.symbol.asciidoc']
    expect(tokens[0][1]).toEqual value: '1', scopes: ['source.asciidoc', 'callout.asciidoc', 'constant.numeric.asciidoc']
    expect(tokens[0][2]).toEqual value: '>', scopes: ['source.asciidoc', 'callout.asciidoc', 'constant.other.symbol.asciidoc']
    expect(tokens[0][3]).toEqual value: ' ', scopes: ['source.asciidoc', 'callout.asciidoc']
    expect(tokens[0][4]).toEqual value: 'foobar', scopes: ['source.asciidoc', 'callout.asciidoc']
    expect(tokens[1]).toHaveLength 5
    expect(tokens[1][0]).toEqual value: '<', scopes: ['source.asciidoc', 'callout.asciidoc', 'constant.other.symbol.asciidoc']
    expect(tokens[1][1]).toEqual value: '2', scopes: ['source.asciidoc', 'callout.asciidoc', 'constant.numeric.asciidoc']
    expect(tokens[1][2]).toEqual value: '>', scopes: ['source.asciidoc', 'callout.asciidoc', 'constant.other.symbol.asciidoc']
    expect(tokens[1][3]).toEqual value: ' ', scopes: ['source.asciidoc', 'callout.asciidoc']
    expect(tokens[1][4]).toEqual value: 'fiibir', scopes: ['source.asciidoc', 'callout.asciidoc']
    expect(tokens[2]).toHaveLength 5
    expect(tokens[2][0]).toEqual value: '<', scopes: ['source.asciidoc', 'callout.asciidoc', 'constant.other.symbol.asciidoc']
    expect(tokens[2][1]).toEqual value: '3', scopes: ['source.asciidoc', 'callout.asciidoc', 'constant.numeric.asciidoc']
    expect(tokens[2][2]).toEqual value: '>', scopes: ['source.asciidoc', 'callout.asciidoc', 'constant.other.symbol.asciidoc']
    expect(tokens[2][3]).toEqual value: ' ', scopes: ['source.asciidoc', 'callout.asciidoc']
    expect(tokens[2][4]).toEqual value: 'feeber', scopes: ['source.asciidoc', 'callout.asciidoc']
