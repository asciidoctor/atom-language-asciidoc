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
    expect(tokens[0]).toEqualJson value: 'foobar ', scopes: ['source.asciidoc']
    expect(tokens[1]).toEqualJson value: '{mylink}', scopes: ['source.asciidoc', 'markup.substitution.attribute-reference.asciidoc']
    expect(tokens[2]).toEqualJson value: ' foobar', scopes: ['source.asciidoc']

  it 'is a simple `counter`', ->
    {tokens} = grammar.tokenizeLine 'foobar {counter:pcount:1} foobar'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqualJson value: 'foobar ', scopes: ['source.asciidoc']
    expect(tokens[1]).toEqualJson value: '{counter:pcount:1}', scopes: ['source.asciidoc', 'markup.substitution.attribute-reference.asciidoc']
    expect(tokens[2]).toEqualJson value: ' foobar', scopes: ['source.asciidoc']

  it 'is a simple `set`', ->
    {tokens} = grammar.tokenizeLine 'foobar {set:foo:bar} foobar'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqualJson value: 'foobar ', scopes: ['source.asciidoc']
    expect(tokens[1]).toEqualJson value: '{set:foo:bar}', scopes: ['source.asciidoc', 'markup.substitution.attribute-reference.asciidoc']
    expect(tokens[2]).toEqualJson value: ' foobar', scopes: ['source.asciidoc']

  describe 'Should not tokenizes inline attribute-reference when', ->

    it '"{" escaped', ->
      {tokens} = grammar.tokenizeLine 'foobar \\\\{mylink} foobar'
      expect(tokens).toHaveLength 1
      expect(tokens[0]).toEqualJson value: 'foobar \\\\{mylink} foobar', scopes: ['source.asciidoc']

    it '"}" escaped', ->
      {tokens} = grammar.tokenizeLine 'foobar {mylink\\\} foobar'
      expect(tokens).toHaveLength 1
      expect(tokens[0]).toEqualJson value: 'foobar {mylink\\\} foobar', scopes: ['source.asciidoc']
