describe 'Should tokenizes stem macro when', ->
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

  it 'contains stem', ->
    {tokens} = grammar.tokenizeLine 'foo stem:[x != 0] bar'
    expect(tokens).toHaveLength 5
    expect(tokens[0]).toEqualJson value: 'foo ', scopes: ['source.asciidoc']
    expect(tokens[1]).toEqualJson value: 'stem:[', scopes: ['source.asciidoc', 'markup.macro.inline.stem.asciidoc']
    expect(tokens[2]).toEqualJson value: 'x != 0', scopes: ['source.asciidoc', 'markup.macro.inline.stem.asciidoc', 'markup.raw.asciidoc']
    expect(tokens[3]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.macro.inline.stem.asciidoc']
    expect(tokens[4]).toEqualJson value: ' bar', scopes: ['source.asciidoc']

  it 'contains asciimath', ->
    {tokens} = grammar.tokenizeLine 'foo asciimath:[x != 0] bar'
    expect(tokens).toHaveLength 5
    expect(tokens[0]).toEqualJson value: 'foo ', scopes: ['source.asciidoc']
    expect(tokens[1]).toEqualJson value: 'asciimath:[', scopes: ['source.asciidoc', 'markup.macro.inline.stem.asciidoc']
    expect(tokens[2]).toEqualJson value: 'x != 0', scopes: ['source.asciidoc', 'markup.macro.inline.stem.asciidoc', 'markup.raw.asciidoc']
    expect(tokens[3]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.macro.inline.stem.asciidoc']
    expect(tokens[4]).toEqualJson value: ' bar', scopes: ['source.asciidoc']

  it 'contains latexmath', ->
    {tokens} = grammar.tokenizeLine 'foo latexmath:[\\sqrt{4} = 2] bar'
    expect(tokens).toHaveLength 5
    expect(tokens[0]).toEqualJson value: 'foo ', scopes: ['source.asciidoc']
    expect(tokens[1]).toEqualJson value: 'latexmath:[', scopes: ['source.asciidoc', 'markup.macro.inline.stem.asciidoc']
    expect(tokens[2]).toEqualJson value: '\\sqrt{4} = 2', scopes: ['source.asciidoc', 'markup.macro.inline.stem.asciidoc', 'markup.raw.asciidoc']
    expect(tokens[3]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.macro.inline.stem.asciidoc']
    expect(tokens[4]).toEqualJson value: ' bar', scopes: ['source.asciidoc']
