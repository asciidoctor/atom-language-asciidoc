describe 'Stem macro', ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage 'language-asciidoc'

    runs ->
      grammar = atom.grammars.grammarForScopeName 'source.asciidoc'

  it 'parses the grammar', ->
    expect(grammar).toBeDefined()
    expect(grammar.scopeName).toBe 'source.asciidoc'

  describe 'Should tokenizes stem macro when', ->

    it 'contains stem', ->
      {tokens} = grammar.tokenizeLine 'foo stem:[x != 0] bar'
      expect(tokens).toHaveLength 6
      expect(tokens[0]).toEqualJson value: 'foo ', scopes: ['source.asciidoc']
      expect(tokens[1]).toEqualJson value: 'stem', scopes: ['source.asciidoc', 'markup.macro.inline.stem.asciidoc', 'entity.name.function.asciidoc']
      expect(tokens[2]).toEqualJson value: ':[', scopes: ['source.asciidoc', 'markup.macro.inline.stem.asciidoc']
      expect(tokens[3]).toEqualJson value: 'x != 0', scopes: ['source.asciidoc', 'markup.macro.inline.stem.asciidoc', 'string.unquoted.asciidoc']
      expect(tokens[4]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.macro.inline.stem.asciidoc']
      expect(tokens[5]).toEqualJson value: ' bar', scopes: ['source.asciidoc']

    it 'contains asciimath', ->
      {tokens} = grammar.tokenizeLine 'foo asciimath:[x != 0] bar'
      expect(tokens).toHaveLength 6
      expect(tokens[0]).toEqualJson value: 'foo ', scopes: ['source.asciidoc']
      expect(tokens[1]).toEqualJson value: 'asciimath', scopes: ['source.asciidoc', 'markup.macro.inline.stem.asciidoc', 'entity.name.function.asciidoc']
      expect(tokens[2]).toEqualJson value: ':[', scopes: ['source.asciidoc', 'markup.macro.inline.stem.asciidoc']
      expect(tokens[3]).toEqualJson value: 'x != 0', scopes: ['source.asciidoc', 'markup.macro.inline.stem.asciidoc', 'string.unquoted.asciidoc']
      expect(tokens[4]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.macro.inline.stem.asciidoc']
      expect(tokens[5]).toEqualJson value: ' bar', scopes: ['source.asciidoc']

    it 'contains latexmath', ->
      {tokens} = grammar.tokenizeLine 'foo latexmath:[\\sqrt{4} = 2] bar'
      expect(tokens).toHaveLength 6
      expect(tokens[0]).toEqualJson value: 'foo ', scopes: ['source.asciidoc']
      expect(tokens[1]).toEqualJson value: 'latexmath', scopes: ['source.asciidoc', 'markup.macro.inline.stem.asciidoc', 'entity.name.function.asciidoc']
      expect(tokens[2]).toEqualJson value: ':[', scopes: ['source.asciidoc', 'markup.macro.inline.stem.asciidoc']
      expect(tokens[3]).toEqualJson value: '\\sqrt{4} = 2', scopes: ['source.asciidoc', 'markup.macro.inline.stem.asciidoc', 'string.unquoted.asciidoc']
      expect(tokens[4]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.macro.inline.stem.asciidoc']
      expect(tokens[5]).toEqualJson value: ' bar', scopes: ['source.asciidoc']
