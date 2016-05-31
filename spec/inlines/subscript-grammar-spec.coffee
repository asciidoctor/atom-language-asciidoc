describe 'Subscript', ->
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

    it 'simple phrase', ->
      {tokens} = grammar.tokenizeLine '~subscript~ is good'
      expect(tokens).toHaveLength 4
      expect(tokens[0]).toEqualJson value: '~', scopes: ['source.asciidoc', 'markup.subscript.asciidoc', 'markup.sub.subscript.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[1]).toEqualJson value: 'subscript', scopes: ['source.asciidoc', 'markup.subscript.asciidoc', 'markup.sub.subscript.asciidoc']
      expect(tokens[2]).toEqualJson value: '~', scopes: ['source.asciidoc', 'markup.subscript.asciidoc', 'markup.sub.subscript.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[3]).toEqualJson value: ' is good', scopes: ['source.asciidoc']

    it 'when having a [role] set on ~subscript~ text', ->
      {tokens} = grammar.tokenizeLine '[role]~subscript~'
      expect(tokens).toHaveLength 4
      expect(tokens[0]).toEqualJson value: '[role]', scopes: ['source.asciidoc', 'markup.subscript.asciidoc', 'markup.meta.sub.attribute-list.asciidoc']
      expect(tokens[1]).toEqualJson value: '~', scopes: ['source.asciidoc', 'markup.subscript.asciidoc', 'markup.sub.subscript.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[2]).toEqualJson value: 'subscript', scopes: ['source.asciidoc', 'markup.subscript.asciidoc', 'markup.sub.subscript.asciidoc']
      expect(tokens[3]).toEqualJson value: '~', scopes: ['source.asciidoc', 'markup.subscript.asciidoc', 'markup.sub.subscript.asciidoc', 'punctuation.definition.asciidoc']

    it 'when having [role1 role2] set on ~subscript~ text', ->
      {tokens} = grammar.tokenizeLine '[role1 role2]~subscript~'
      expect(tokens).toHaveLength 4
      expect(tokens[0]).toEqualJson value: '[role1 role2]', scopes: ['source.asciidoc', 'markup.subscript.asciidoc', 'markup.meta.sub.attribute-list.asciidoc']
      expect(tokens[1]).toEqualJson value: '~', scopes: ['source.asciidoc', 'markup.subscript.asciidoc', 'markup.sub.subscript.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[2]).toEqualJson value: 'subscript', scopes: ['source.asciidoc', 'markup.subscript.asciidoc', 'markup.sub.subscript.asciidoc']
      expect(tokens[3]).toEqualJson value: '~', scopes: ['source.asciidoc', 'markup.subscript.asciidoc', 'markup.sub.subscript.asciidoc', 'punctuation.definition.asciidoc']
