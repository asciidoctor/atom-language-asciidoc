describe 'Should tokenizes inline attribute-reference when', ->
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

  it 'is in a phrase', ->
    {tokens} = grammar.tokenizeLine 'foobar {mylink} foobar'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqual value: 'foobar ', scopes: ['source.asciidoc']
    expect(tokens[1]).toEqual value: '{mylink}', scopes: ['source.asciidoc', 'markup.substitution.attribute-reference.asciidoc']
    expect(tokens[2]).toEqual value: ' foobar', scopes: ['source.asciidoc']

  it 'is a simple `counter`', ->
    {tokens} = grammar.tokenizeLine 'foobar {counter:pcount:1} foobar'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqual value: 'foobar ', scopes: ['source.asciidoc']
    expect(tokens[1]).toEqual value: '{counter:pcount:1}', scopes: ['source.asciidoc', 'markup.substitution.attribute-reference.asciidoc']
    expect(tokens[2]).toEqual value: ' foobar', scopes: ['source.asciidoc']

  it 'is a simple `set`', ->
    {tokens} = grammar.tokenizeLine 'foobar {set:foo:bar} foobar'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqual value: 'foobar ', scopes: ['source.asciidoc']
    expect(tokens[1]).toEqual value: '{set:foo:bar}', scopes: ['source.asciidoc', 'markup.substitution.attribute-reference.asciidoc']
    expect(tokens[2]).toEqual value: ' foobar', scopes: ['source.asciidoc']
