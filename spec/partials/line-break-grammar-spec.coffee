describe 'Should tokenize line break when', ->
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

  it 'contains simple character', ->
    tokens = grammar.tokenizeLines '''
       +
      Foo +
      '''
    expect(tokens).toHaveLength 2
    expect(tokens[0]).toHaveLength 2
    expect(tokens[0][0]).toEqual value: ' ', scopes: ['source.asciidoc']
    expect(tokens[0][1]).toEqual value: '+', scopes: ['source.asciidoc', 'variable.line-break.asciidoc']
    expect(tokens[1]).toHaveLength 3
    expect(tokens[1][0]).toEqual value: 'Foo', scopes: ['source.asciidoc']
    expect(tokens[1][1]).toEqual value: ' ', scopes: ['source.asciidoc']
    expect(tokens[1][2]).toEqual value: '+', scopes: ['source.asciidoc', 'variable.line-break.asciidoc']

  it 'ending with strong', ->
    {tokens} = grammar.tokenizeLine 'Rubies are *red* +'
    expect(tokens).toHaveLength 6
    expect(tokens[0]).toEqual value: 'Rubies are ', scopes: ['source.asciidoc']
    expect(tokens[1]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.bold.constrained.asciidoc', 'support.constant.asciidoc']
    expect(tokens[2]).toEqual value: 'red', scopes: ['source.asciidoc', 'markup.bold.constrained.asciidoc']
    expect(tokens[3]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.bold.constrained.asciidoc', 'support.constant.asciidoc']
    expect(tokens[4]).toEqual value: ' ', scopes: ['source.asciidoc']
    expect(tokens[5]).toEqual value: '+', scopes: ['source.asciidoc', 'variable.line-break.asciidoc']
