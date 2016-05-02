describe 'Should tokenizes xref when', ->
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

  it '<<reference>> elements', ->
    {tokens} = grammar.tokenizeLine 'foobar <<id,reftext>> foobar'
    expect(tokens).toHaveLength 5
    expect(tokens[0]).toEqual value: 'foobar ', scopes: ['source.asciidoc']
    expect(tokens[1]).toEqual value: '<<', scopes: ['source.asciidoc', 'markup.reference.xref.asciidoc', 'constant.asciidoc']
    expect(tokens[2]).toEqual value: 'id,reftext', scopes: ['source.asciidoc', 'markup.reference.xref.asciidoc']
    expect(tokens[3]).toEqual value: '>>', scopes: ['source.asciidoc', 'markup.reference.xref.asciidoc', 'constant.asciidoc']
    expect(tokens[4]).toEqual value: ' foobar', scopes: ['source.asciidoc']

  it 'tokenizes xref:id[reference] elements', ->
    {tokens} = grammar.tokenizeLine 'foobar xref:id[reftext] foobar'
    expect(tokens).toHaveLength 5
    expect(tokens[0]).toEqual value: 'foobar ', scopes: ['source.asciidoc']
    expect(tokens[1]).toEqual value: 'xref:', scopes: ['source.asciidoc', 'markup.reference.xref.asciidoc', 'constant.asciidoc']
    expect(tokens[2]).toEqual value: 'id', scopes: ['source.asciidoc', 'markup.reference.xref.asciidoc', 'constant.id.xref.asciidoc']
    expect(tokens[3]).toEqual value: '[reftext]', scopes: ['source.asciidoc', 'markup.reference.xref.asciidoc']
    expect(tokens[4]).toEqual value: ' foobar', scopes: ['source.asciidoc']
