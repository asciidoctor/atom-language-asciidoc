describe 'Should tokenizes text link when', ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage 'language-asciidoc'

    runs ->
      grammar = atom.grammars.grammarForScopeName 'source.asciidoc'

  it 'parses the grammar', ->
    expect(grammar).toBeDefined()
    expect(grammar.scopeName).toBe 'source.asciidoc'

  describe 'general inline macro', ->

    it 'parses `link`-like macro', ->
      {tokens} = grammar.tokenizeLine 'See cite:[Knuth1999] for more details'
      expect(tokens).toHaveLength 6
      expect(tokens[0]).toEqualJson value: 'See ', scopes: ['source.asciidoc']
      expect(tokens[1]).toEqualJson value: 'cite', scopes: ['source.asciidoc', 'markup.other.inline.asciidoc', 'entity.name.function.asciidoc']
      expect(tokens[2]).toEqualJson value: ':[', scopes: ['source.asciidoc', 'markup.other.inline.asciidoc']
      expect(tokens[3]).toEqualJson value: 'Knuth1999', scopes: ['source.asciidoc', 'markup.other.inline.asciidoc', 'string.unquoted.asciidoc']
      expect(tokens[4]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.other.inline.asciidoc']
      expect(tokens[5]).toEqualJson value: ' for more details', scopes: ['source.asciidoc']

    it 'parses `image`-like macro', ->
      {tokens} = grammar.tokenizeLine 'This is user:defined[macro] for demo'
      expect(tokens).toHaveLength 8
      expect(tokens[0]).toEqualJson value: 'This is ', scopes: ['source.asciidoc']
      expect(tokens[1]).toEqualJson value: 'user', scopes: ['source.asciidoc', 'markup.other.inline.asciidoc', 'entity.name.function.asciidoc']
      expect(tokens[2]).toEqualJson value: ':', scopes: ['source.asciidoc', 'markup.other.inline.asciidoc']
      expect(tokens[3]).toEqualJson value: 'defined', scopes: ['source.asciidoc', 'markup.other.inline.asciidoc', 'markup.link.asciidoc']
      expect(tokens[4]).toEqualJson value: '[', scopes: ['source.asciidoc', 'markup.other.inline.asciidoc']
      expect(tokens[5]).toEqualJson value: 'macro', scopes: ['source.asciidoc', 'markup.other.inline.asciidoc', 'string.unquoted.asciidoc']
      expect(tokens[6]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.other.inline.asciidoc']
      expect(tokens[7]).toEqualJson value: ' for demo', scopes: ['source.asciidoc']
