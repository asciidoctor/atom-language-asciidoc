describe 'Inline attribute-reference', ->
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

    it 'is in a phrase', ->
      {tokens} = grammar.tokenizeLine 'foobar {mylink} foobar'
      expect(tokens).toHaveLength 3
      expect(tokens[0]).toEqualJson value: 'foobar ', scopes: ['source.asciidoc']
      expect(tokens[1]).toEqualJson value: '{mylink}', scopes: ['source.asciidoc', 'markup.substitution.attribute-reference.asciidoc']
      expect(tokens[2]).toEqualJson value: ' foobar', scopes: ['source.asciidoc']

    it 'is an attribute definition `counter`', ->
      {tokens} = grammar.tokenizeLine 'foobar {counter:pcount:1} foobar'
      expect(tokens).toHaveLength 9
      partIndex = 0
      expect(tokens[partIndex++]).toEqualJson value: 'foobar ', scopes: ['source.asciidoc']
      expect(tokens[partIndex++]).toEqualJson value: '{', scopes: ['source.asciidoc', 'markup.substitution.attribute-reference.asciidoc']
      expect(tokens[partIndex++]).toEqualJson value: 'counter', scopes: ['source.asciidoc', 'markup.substitution.attribute-reference.asciidoc', 'entity.name.function.asciidoc']
      expect(tokens[partIndex++]).toEqualJson value: ':', scopes: ['source.asciidoc', 'markup.substitution.attribute-reference.asciidoc', 'punctuation.separator.asciidoc']
      expect(tokens[partIndex++]).toEqualJson value: 'pcount', scopes: ['source.asciidoc', 'markup.substitution.attribute-reference.asciidoc', 'support.constant.attribute-name.asciidoc']
      expect(tokens[partIndex++]).toEqualJson value: ':', scopes: ['source.asciidoc', 'markup.substitution.attribute-reference.asciidoc', 'punctuation.separator.asciidoc']
      expect(tokens[partIndex++]).toEqualJson value: '1', scopes: ['source.asciidoc', 'markup.substitution.attribute-reference.asciidoc', 'string.unquoted.attribute-value.asciidoc']
      expect(tokens[partIndex++]).toEqualJson value: '}', scopes: ['source.asciidoc', 'markup.substitution.attribute-reference.asciidoc']
      expect(tokens[partIndex++]).toEqualJson value: ' foobar', scopes: ['source.asciidoc']
      expect(partIndex).toBe 9

    it 'is a an attribute definition `set`', ->
      {tokens} = grammar.tokenizeLine 'foobar {set:foo:bar} foobar'
      expect(tokens).toHaveLength 9
      partIndex = 0
      expect(tokens[partIndex++]).toEqualJson value: 'foobar ', scopes: ['source.asciidoc']
      expect(tokens[partIndex++]).toEqualJson value: '{', scopes: ['source.asciidoc', 'markup.substitution.attribute-reference.asciidoc']
      expect(tokens[partIndex++]).toEqualJson value: 'set', scopes: ['source.asciidoc', 'markup.substitution.attribute-reference.asciidoc', 'entity.name.function.asciidoc']
      expect(tokens[partIndex++]).toEqualJson value: ':', scopes: ['source.asciidoc', 'markup.substitution.attribute-reference.asciidoc', 'punctuation.separator.asciidoc']
      expect(tokens[partIndex++]).toEqualJson value: 'foo', scopes: ['source.asciidoc', 'markup.substitution.attribute-reference.asciidoc', 'support.constant.attribute-name.asciidoc']
      expect(tokens[partIndex++]).toEqualJson value: ':', scopes: ['source.asciidoc', 'markup.substitution.attribute-reference.asciidoc', 'punctuation.separator.asciidoc']
      expect(tokens[partIndex++]).toEqualJson value: 'bar', scopes: ['source.asciidoc', 'markup.substitution.attribute-reference.asciidoc', 'string.unquoted.attribute-value.asciidoc']
      expect(tokens[partIndex++]).toEqualJson value: '}', scopes: ['source.asciidoc', 'markup.substitution.attribute-reference.asciidoc']
      expect(tokens[partIndex++]).toEqualJson value: ' foobar', scopes: ['source.asciidoc']
      expect(partIndex).toBe 9

  describe 'Should not tokenizes when', ->

    it '"{" escaped', ->
      {tokens} = grammar.tokenizeLine 'foobar \\\\{mylink} foobar'
      expect(tokens).toHaveLength 1
      expect(tokens[0]).toEqualJson value: 'foobar \\\\{mylink} foobar', scopes: ['source.asciidoc']

    it '"}" escaped', ->
      {tokens} = grammar.tokenizeLine 'foobar {mylink\\\} foobar'
      expect(tokens).toHaveLength 1
      expect(tokens[0]).toEqualJson value: 'foobar {mylink\\\} foobar', scopes: ['source.asciidoc']
