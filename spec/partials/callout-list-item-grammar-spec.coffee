describe 'Should tokenizes callout list item when', ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage 'language-asciidoc'

    runs ->
      grammar = atom.grammars.grammarForScopeName 'source.asciidoc'

  it 'parses the grammar', ->
    expect(grammar).toBeDefined()
    expect(grammar.scopeName).toBe 'source.asciidoc'

  it 'contains simple callout', ->
    {tokens} = grammar.tokenizeLine '<1> foobar'
    expect(tokens).toHaveLength 5
    expect(tokens[0]).toEqualJson value: '<', scopes: ['source.asciidoc', 'callout.asciidoc', 'constant.other.symbol.asciidoc']
    expect(tokens[1]).toEqualJson value: '1', scopes: ['source.asciidoc', 'callout.asciidoc', 'constant.numeric.asciidoc']
    expect(tokens[2]).toEqualJson value: '>', scopes: ['source.asciidoc', 'callout.asciidoc', 'constant.other.symbol.asciidoc']
    expect(tokens[3]).toEqualJson value: ' ', scopes: ['source.asciidoc', 'callout.asciidoc']
    expect(tokens[4]).toEqualJson value: 'foobar', scopes: ['source.asciidoc', 'callout.asciidoc']

  it 'contains callout mixed with inline element', ->
    {tokens} = grammar.tokenizeLine '<1> *Grammars* _definition_'
    expect(tokens).toHaveLength 11
    expect(tokens[0]).toEqualJson value: '<', scopes: ['source.asciidoc', 'callout.asciidoc', 'constant.other.symbol.asciidoc']
    expect(tokens[1]).toEqualJson value: '1', scopes: ['source.asciidoc', 'callout.asciidoc', 'constant.numeric.asciidoc']
    expect(tokens[2]).toEqualJson value: '>', scopes: ['source.asciidoc', 'callout.asciidoc', 'constant.other.symbol.asciidoc']
    expect(tokens[3]).toEqualJson value: ' ', scopes: ['source.asciidoc', 'callout.asciidoc']
    expect(tokens[4]).toEqualJson value: '*', scopes: ['source.asciidoc', 'callout.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc', 'punctuation.definition.asciidoc']
    expect(tokens[5]).toEqualJson value: 'Grammars', scopes: ['source.asciidoc', 'callout.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc']
    expect(tokens[6]).toEqualJson value: '*', scopes: ['source.asciidoc', 'callout.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc', 'punctuation.definition.asciidoc']
    expect(tokens[7]).toEqualJson value: ' ', scopes: ['source.asciidoc', 'callout.asciidoc']
    expect(tokens[8]).toEqualJson value: '_', scopes: ['source.asciidoc', 'callout.asciidoc', 'markup.emphasis.constrained.asciidoc', 'markup.italic.asciidoc', 'punctuation.definition.asciidoc']
    expect(tokens[9]).toEqualJson value: 'definition', scopes: ['source.asciidoc', 'callout.asciidoc', 'markup.emphasis.constrained.asciidoc', 'markup.italic.asciidoc']
    expect(tokens[10]).toEqualJson value: '_', scopes: ['source.asciidoc', 'callout.asciidoc', 'markup.emphasis.constrained.asciidoc', 'markup.italic.asciidoc', 'punctuation.definition.asciidoc']

  it 'contains misplaced callout (invalid context)', ->
    {tokens} = grammar.tokenizeLine '   <1> foobar'
    expect(tokens).toHaveLength 1
    expect(tokens[0]).toEqualJson value: '   <1> foobar', scopes: ['source.asciidoc']

  it 'contains multiple callout', ->
    tokens = grammar.tokenizeLines '''
                                      <1> foobar
                                      <2> fiibir
                                      <3> feeber
                                      '''
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toHaveLength 5
    expect(tokens[0][0]).toEqualJson value: '<', scopes: ['source.asciidoc', 'callout.asciidoc', 'constant.other.symbol.asciidoc']
    expect(tokens[0][1]).toEqualJson value: '1', scopes: ['source.asciidoc', 'callout.asciidoc', 'constant.numeric.asciidoc']
    expect(tokens[0][2]).toEqualJson value: '>', scopes: ['source.asciidoc', 'callout.asciidoc', 'constant.other.symbol.asciidoc']
    expect(tokens[0][3]).toEqualJson value: ' ', scopes: ['source.asciidoc', 'callout.asciidoc']
    expect(tokens[0][4]).toEqualJson value: 'foobar', scopes: ['source.asciidoc', 'callout.asciidoc']
    expect(tokens[1]).toHaveLength 5
    expect(tokens[1][0]).toEqualJson value: '<', scopes: ['source.asciidoc', 'callout.asciidoc', 'constant.other.symbol.asciidoc']
    expect(tokens[1][1]).toEqualJson value: '2', scopes: ['source.asciidoc', 'callout.asciidoc', 'constant.numeric.asciidoc']
    expect(tokens[1][2]).toEqualJson value: '>', scopes: ['source.asciidoc', 'callout.asciidoc', 'constant.other.symbol.asciidoc']
    expect(tokens[1][3]).toEqualJson value: ' ', scopes: ['source.asciidoc', 'callout.asciidoc']
    expect(tokens[1][4]).toEqualJson value: 'fiibir', scopes: ['source.asciidoc', 'callout.asciidoc']
    expect(tokens[2]).toHaveLength 5
    expect(tokens[2][0]).toEqualJson value: '<', scopes: ['source.asciidoc', 'callout.asciidoc', 'constant.other.symbol.asciidoc']
    expect(tokens[2][1]).toEqualJson value: '3', scopes: ['source.asciidoc', 'callout.asciidoc', 'constant.numeric.asciidoc']
    expect(tokens[2][2]).toEqualJson value: '>', scopes: ['source.asciidoc', 'callout.asciidoc', 'constant.other.symbol.asciidoc']
    expect(tokens[2][3]).toEqualJson value: ' ', scopes: ['source.asciidoc', 'callout.asciidoc']
    expect(tokens[2][4]).toEqualJson value: 'feeber', scopes: ['source.asciidoc', 'callout.asciidoc']
