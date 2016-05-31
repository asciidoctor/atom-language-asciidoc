describe 'Footnote macro', ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage 'language-asciidoc'

    runs ->
      grammar = atom.grammars.grammarForScopeName 'source.asciidoc'

  it 'parses the grammar', ->
    expect(grammar).toBeDefined()
    expect(grammar.scopeName).toBe 'source.asciidoc'

  describe 'Should tokenizes when', ->

    it 'simple footnote', ->
      {tokens} = grammar.tokenizeLine 'footnote:[text]'
      expect(tokens).toHaveLength 4
      expect(tokens[0]).toEqualJson value: 'footnote', scopes: ['source.asciidoc', 'markup.other.footnote.asciidoc', 'entity.name.function.asciidoc']
      expect(tokens[1]).toEqualJson value: ':[', scopes: ['source.asciidoc', 'markup.other.footnote.asciidoc']
      expect(tokens[2]).toEqualJson value: 'text', scopes: ['source.asciidoc', 'markup.other.footnote.asciidoc', 'string.unquoted.asciidoc']
      expect(tokens[3]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.other.footnote.asciidoc']

    it 'simple footnote with formatted text', ->
      {tokens} = grammar.tokenizeLine 'footnote:[*text*]'
      expect(tokens).toHaveLength 6
      expect(tokens[0]).toEqualJson value: 'footnote', scopes: ['source.asciidoc', 'markup.other.footnote.asciidoc', 'entity.name.function.asciidoc']
      expect(tokens[1]).toEqualJson value: ':[', scopes: ['source.asciidoc', 'markup.other.footnote.asciidoc']
      expect(tokens[3]).toEqualJson value: 'text', scopes: ['source.asciidoc', 'markup.other.footnote.asciidoc', 'string.unquoted.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc']
      expect(tokens[5]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.other.footnote.asciidoc']

    it 'simple footnoteref with id and text', ->
      {tokens} = grammar.tokenizeLine 'footnoteref:[id,text]'
      expect(tokens).toHaveLength 4
      expect(tokens[0]).toEqualJson value: 'footnoteref', scopes: ['source.asciidoc', 'markup.other.footnote.asciidoc', 'entity.name.function.asciidoc']
      expect(tokens[1]).toEqualJson value: ':[', scopes: ['source.asciidoc', 'markup.other.footnote.asciidoc']
      expect(tokens[2]).toEqualJson value: 'id,text', scopes: ['source.asciidoc', 'markup.other.footnote.asciidoc', 'string.unquoted.asciidoc']
      expect(tokens[3]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.other.footnote.asciidoc']

    it 'simple footnoteref with id', ->
      {tokens} = grammar.tokenizeLine 'footnoteref:[id]'
      expect(tokens).toHaveLength 4
      expect(tokens[0]).toEqualJson value: 'footnoteref', scopes: ['source.asciidoc', 'markup.other.footnote.asciidoc', 'entity.name.function.asciidoc']
      expect(tokens[1]).toEqualJson value: ':[', scopes: ['source.asciidoc', 'markup.other.footnote.asciidoc']
      expect(tokens[2]).toEqualJson value: 'id', scopes: ['source.asciidoc', 'markup.other.footnote.asciidoc', 'string.unquoted.asciidoc']
      expect(tokens[3]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.other.footnote.asciidoc']
