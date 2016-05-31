describe 'Superscript', ->
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
      {tokens} = grammar.tokenizeLine '^superscript^ is good'
      expect(tokens).toHaveLength 4
      expect(tokens[0]).toEqualJson value: '^', scopes: ['source.asciidoc', 'markup.superscript.asciidoc', 'markup.super.superscript.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[1]).toEqualJson value: 'superscript', scopes: ['source.asciidoc', 'markup.superscript.asciidoc', 'markup.super.superscript.asciidoc']
      expect(tokens[2]).toEqualJson value: '^', scopes: ['source.asciidoc', 'markup.superscript.asciidoc', 'markup.super.superscript.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[3]).toEqualJson value: ' is good', scopes: ['source.asciidoc']

    it 'when having a [role] set on ^superscript^ text', ->
      {tokens} = grammar.tokenizeLine '[role]^superscript^'
      expect(tokens).toHaveLength 4
      expect(tokens[0]).toEqualJson value: '[role]', scopes: ['source.asciidoc', 'markup.superscript.asciidoc', 'markup.meta.super.attribute-list.asciidoc']
      expect(tokens[1]).toEqualJson value: '^', scopes: ['source.asciidoc', 'markup.superscript.asciidoc', 'markup.super.superscript.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[2]).toEqualJson value: 'superscript', scopes: ['source.asciidoc', 'markup.superscript.asciidoc', 'markup.super.superscript.asciidoc']
      expect(tokens[3]).toEqualJson value: '^', scopes: ['source.asciidoc', 'markup.superscript.asciidoc', 'markup.super.superscript.asciidoc', 'punctuation.definition.asciidoc']

    it 'when having [role1 role2] set on ^superscript^ text', ->
      {tokens} = grammar.tokenizeLine '[role1 role2]^superscript^'
      expect(tokens).toHaveLength 4
      expect(tokens[0]).toEqualJson value: '[role1 role2]', scopes: ['source.asciidoc', 'markup.superscript.asciidoc', 'markup.meta.super.attribute-list.asciidoc']
      expect(tokens[1]).toEqualJson value: '^', scopes: ['source.asciidoc', 'markup.superscript.asciidoc', 'markup.super.superscript.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[2]).toEqualJson value: 'superscript', scopes: ['source.asciidoc', 'markup.superscript.asciidoc', 'markup.super.superscript.asciidoc']
      expect(tokens[3]).toEqualJson value: '^', scopes: ['source.asciidoc', 'markup.superscript.asciidoc', 'markup.super.superscript.asciidoc', 'punctuation.definition.asciidoc']
