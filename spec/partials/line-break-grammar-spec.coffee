describe 'Should tokenize line break when', ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage 'language-asciidoc'

    runs ->
      grammar = atom.grammars.grammarForScopeName 'source.asciidoc'

  it 'parses the grammar', ->
    expect(grammar).toBeDefined()
    expect(grammar.scopeName).toBe 'source.asciidoc'

  it 'contains simple character', ->
    tokens = grammar.tokenizeLines '''
      Foo +
      Bar
      '''
    expect(tokens).toHaveLength 2
    expect(tokens[0]).toHaveLength 3
    expect(tokens[0][0]).toEqualJson value: 'Foo', scopes: ['source.asciidoc']
    expect(tokens[0][1]).toEqualJson value: ' ', scopes: ['source.asciidoc']
    expect(tokens[0][2]).toEqualJson value: '+', scopes: ['source.asciidoc', 'variable.line-break.asciidoc']
    expect(tokens[1]).toHaveLength 1
    expect(tokens[1][0]).toEqualJson value: 'Bar', scopes: ['source.asciidoc']

  it 'ending with strong', ->
    {tokens} = grammar.tokenizeLine 'Rubies are *red* +'
    expect(tokens).toHaveLength 6
    expect(tokens[0]).toEqualJson value: 'Rubies are ', scopes: ['source.asciidoc']
    expect(tokens[1]).toEqualJson value: '*', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc', 'punctuation.definition.asciidoc']
    expect(tokens[2]).toEqualJson value: 'red', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc']
    expect(tokens[3]).toEqualJson value: '*', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc', 'punctuation.definition.asciidoc']
    expect(tokens[4]).toEqualJson value: ' ', scopes: ['source.asciidoc']
    expect(tokens[5]).toEqualJson value: '+', scopes: ['source.asciidoc', 'variable.line-break.asciidoc']
