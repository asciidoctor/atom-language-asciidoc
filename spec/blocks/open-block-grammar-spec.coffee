describe 'Should tokenizes open block when', ->
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

  it 'contains simple phrase', ->
    tokens = grammar.tokenizeLines '''
      --
      foobar, foobar and foobar
      --
      '''
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toHaveLength 1
    expect(tokens[0][0]).toEqualJson value: '--', scopes: ['source.asciidoc', 'markup.raw.open.asciidoc']
    expect(tokens[1]).toHaveLength 1
    expect(tokens[1][0]).toEqualJson value: 'foobar, foobar and foobar', scopes: ['source.asciidoc', 'markup.raw.open.asciidoc']
    expect(tokens[2]).toHaveLength 1
    expect(tokens[2][0]).toEqualJson value: '--', scopes: ['source.asciidoc', 'markup.raw.open.asciidoc']
