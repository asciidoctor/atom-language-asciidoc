describe 'xref', ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage 'language-asciidoc'

    runs ->
      grammar = atom.grammars.grammarForScopeName 'source.asciidoc'

  it 'parses the grammar', ->
    expect(grammar).toBeDefined()
    expect(grammar.scopeName).toBe 'source.asciidoc'

  describe 'should tokenizes when', ->

    it '<<reference>> elements', ->
      {tokens} = grammar.tokenizeLine 'foobar <<id,reftext>> foobar'
      expect(tokens).toHaveLength 6
      expect(tokens[0]).toEqualJson value: 'foobar ', scopes: ['source.asciidoc']
      expect(tokens[1]).toEqualJson value: '<<', scopes: ['source.asciidoc', 'markup.reference.xref.asciidoc', 'constant.asciidoc']
      expect(tokens[2]).toEqualJson value: 'id,', scopes: ['source.asciidoc', 'markup.reference.xref.asciidoc', 'markup.meta.attribute-list.asciidoc']
      expect(tokens[3]).toEqualJson value: 'reftext', scopes: ['source.asciidoc', 'markup.reference.xref.asciidoc', 'string.unquoted.asciidoc']
      expect(tokens[4]).toEqualJson value: '>>', scopes: ['source.asciidoc', 'markup.reference.xref.asciidoc', 'constant.asciidoc']
      expect(tokens[5]).toEqualJson value: ' foobar', scopes: ['source.asciidoc']

    it 'tokenizes xref:id[reference] elements', ->
      {tokens} = grammar.tokenizeLine 'foobar xref:id[reftext] foobar'
      expect(tokens).toHaveLength 7
      expect(tokens[0]).toEqualJson value: 'foobar ', scopes: ['source.asciidoc']
      expect(tokens[1]).toEqualJson value: 'xref:', scopes: ['source.asciidoc', 'markup.reference.xref.asciidoc', 'entity.name.function.asciidoc']
      expect(tokens[2]).toEqualJson value: 'id', scopes: ['source.asciidoc', 'markup.reference.xref.asciidoc', 'markup.meta.attribute-list.asciidoc']
      expect(tokens[3]).toEqualJson value: '[', scopes: ['source.asciidoc', 'markup.reference.xref.asciidoc']
      expect(tokens[4]).toEqualJson value: 'reftext', scopes: ['source.asciidoc', 'markup.reference.xref.asciidoc', 'string.unquoted.asciidoc']
      expect(tokens[5]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.reference.xref.asciidoc']
      expect(tokens[6]).toEqualJson value: ' foobar', scopes: ['source.asciidoc']
