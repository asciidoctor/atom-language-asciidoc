describe 'Properties grammar', ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage 'language-asciidoc'

    runs ->
      grammar = atom.grammars.grammarForScopeName 'source.asciidoc.properties'

  # convenience function during development
  debug = (tokens) ->
    console.log(JSON.stringify(tokens, null, ' '))

  it 'load the "properties" config grammar', ->
    expect(grammar).toBeTruthy()
    expect(grammar.scopeName).toBe 'source.asciidoc.properties'

  describe 'Should parse "section" when', ->
    it 'was a simple word', ->
      {tokens} = grammar.tokenizeLine '[foobar]'
      expect(tokens).toHaveLength 3
      expect(tokens[0]).toEqual value: '[', scopes: ['source.asciidoc.properties', 'meta.section.asciidoc.properties']
      expect(tokens[1]).toEqual value: 'foobar', scopes: ['source.asciidoc.properties', 'meta.section.asciidoc.properties', 'entity.name.section.asciidoc.properties']
      expect(tokens[2]).toEqual value: ']', scopes: ['source.asciidoc.properties', 'meta.section.asciidoc.properties']

    it 'have a subsection separate by a dot', ->
      {tokens} = grammar.tokenizeLine '[foo.bar]'
      expect(tokens).toHaveLength 5
      expect(tokens[0]).toEqual value: '[', scopes: ['source.asciidoc.properties', 'meta.section.asciidoc.properties']
      expect(tokens[1]).toEqual value: 'foo', scopes: ['source.asciidoc.properties', 'meta.section.asciidoc.properties', 'entity.name.section.asciidoc.properties']
      expect(tokens[2]).toEqual value: '.', scopes: ['source.asciidoc.properties', 'meta.section.asciidoc.properties']
      expect(tokens[3]).toEqual value: 'bar', scopes: ['source.asciidoc.properties', 'meta.section.asciidoc.properties', 'entity.name.section.subsection.asciidoc.properties']
      expect(tokens[4]).toEqual value: ']', scopes: ['source.asciidoc.properties', 'meta.section.asciidoc.properties']

    it 'have a subsection with double-quote', ->
      {tokens} = grammar.tokenizeLine '[foo "bar"]'
      expect(tokens).toHaveLength 7
      expect(tokens[0]).toEqual value: '[', scopes: ['source.asciidoc.properties', 'meta.section.asciidoc.properties']
      expect(tokens[1]).toEqual value: 'foo', scopes: ['source.asciidoc.properties', 'meta.section.asciidoc.properties', 'entity.name.section.asciidoc.properties']
      expect(tokens[2]).toEqual value: ' ', scopes: ['source.asciidoc.properties', 'meta.section.asciidoc.properties']
      expect(tokens[3]).toEqual value: '"', scopes: ['source.asciidoc.properties', 'meta.section.asciidoc.properties', 'entity.name.section.subsection.asciidoc.properties', 'punctuation.definition.section.subsection.begin.asciidoc.properties']
      expect(tokens[4]).toEqual value: 'bar', scopes: ['source.asciidoc.properties', 'meta.section.asciidoc.properties', 'entity.name.section.subsection.asciidoc.properties']
      expect(tokens[5]).toEqual value: '"', scopes: ['source.asciidoc.properties', 'meta.section.asciidoc.properties', 'entity.name.section.subsection.asciidoc.properties', 'punctuation.definition.section.subsection.end.asciidoc.properties']
      expect(tokens[6]).toEqual value: ']', scopes: ['source.asciidoc.properties', 'meta.section.asciidoc.properties']

  describe 'Should parse "comment" when', ->
    it 'start by a hash', ->
      {tokens} = grammar.tokenizeLine '# comment'
      expect(tokens).toHaveLength 2
      expect(tokens[0]).toEqual value: '#', scopes: ['source.asciidoc.properties', 'comment.line.number-sign.asciidoc.properties', 'punctuation.definition.comment.asciidoc.properties']
      expect(tokens[1]).toEqual value: ' comment', scopes: ['source.asciidoc.properties', 'comment.line.number-sign.asciidoc.properties']

    it 'start by a ;', ->
      {tokens} = grammar.tokenizeLine '; comment'
      expect(tokens).toHaveLength 2
      expect(tokens[0]).toEqual value: ';', scopes: ['source.asciidoc.properties', 'comment.line.number-sign.asciidoc.properties', 'punctuation.definition.comment.asciidoc.properties']
      expect(tokens[1]).toEqual value: ' comment', scopes: ['source.asciidoc.properties', 'comment.line.number-sign.asciidoc.properties']

  describe 'Should parse "value pair" when', ->
    it 'have a simple value', ->
      {tokens} = grammar.tokenizeLine 'name = foobar'
      expect(tokens).toHaveLength 5
      expect(tokens[0]).toEqual value: 'name', scopes: ['source.asciidoc.properties', 'meta.value-pair.section-item.asciidoc.properties', 'punctuation.definition.entity.asciidoc.properties']
      expect(tokens[1]).toEqual value: ' ', scopes: ['source.asciidoc.properties', 'meta.value-pair.section-item.asciidoc.properties']
      expect(tokens[2]).toEqual value: '=', scopes: ['source.asciidoc.properties', 'meta.value-pair.section-item.asciidoc.properties', 'punctuation.separator.key-value.asciidoc.properties']
      expect(tokens[3]).toEqual value: ' ', scopes: ['source.asciidoc.properties', 'meta.value-pair.section-item.asciidoc.properties']
      expect(tokens[4]).toEqual value: 'foobar', scopes: ['source.asciidoc.properties', 'meta.value-pair.section-item.asciidoc.properties']

    it 'have a value embedded in double quote', ->
      {tokens} = grammar.tokenizeLine 'name = "foobar"'
      expect(tokens).toHaveLength 7
      expect(tokens[0]).toEqual value: 'name', scopes: ['source.asciidoc.properties', 'meta.value-pair.section-item.asciidoc.properties', 'punctuation.definition.entity.asciidoc.properties']
      expect(tokens[1]).toEqual value: ' ', scopes: ['source.asciidoc.properties', 'meta.value-pair.section-item.asciidoc.properties']
      expect(tokens[2]).toEqual value: '=', scopes: ['source.asciidoc.properties', 'meta.value-pair.section-item.asciidoc.properties', 'punctuation.separator.key-value.asciidoc.properties']
      expect(tokens[3]).toEqual value: ' ', scopes: ['source.asciidoc.properties', 'meta.value-pair.section-item.asciidoc.properties']
      expect(tokens[4]).toEqual value: '"', scopes: ['source.asciidoc.properties', 'meta.value-pair.section-item.asciidoc.properties', 'string.quoted.double.asciidoc.properties', 'punctuation.definition.string.begin.asciidoc.properties']
      expect(tokens[5]).toEqual value: 'foobar', scopes: ['source.asciidoc.properties', 'meta.value-pair.section-item.asciidoc.properties', 'string.quoted.double.asciidoc.properties']
      expect(tokens[6]).toEqual value: '"', scopes: ['source.asciidoc.properties', 'meta.value-pair.section-item.asciidoc.properties', 'string.quoted.double.asciidoc.properties', 'punctuation.definition.string.end.asciidoc.properties']

    it 'have a boolean value', ->
      {tokens} = grammar.tokenizeLine 'name = true'
      expect(tokens).toHaveLength 5
      expect(tokens[0]).toEqual value: 'name', scopes: ['source.asciidoc.properties', 'meta.value-pair.section-item.asciidoc.properties', 'punctuation.definition.entity.asciidoc.properties']
      expect(tokens[1]).toEqual value: ' ', scopes: ['source.asciidoc.properties', 'meta.value-pair.section-item.asciidoc.properties']
      expect(tokens[2]).toEqual value: '=', scopes: ['source.asciidoc.properties', 'meta.value-pair.section-item.asciidoc.properties', 'punctuation.separator.key-value.asciidoc.properties']
      expect(tokens[3]).toEqual value: ' ', scopes: ['source.asciidoc.properties', 'meta.value-pair.section-item.asciidoc.properties']
      expect(tokens[4]).toEqual value: 'true', scopes: ['source.asciidoc.properties', 'meta.value-pair.section-item.asciidoc.properties', 'constant.language.boolean.asciidoc.properties']

    it 'have a value contains escaped double quote', ->
      {tokens} = grammar.tokenizeLine 'name = \\"foobar\\"'
      expect(tokens).toHaveLength 7
      expect(tokens[0]).toEqual value: 'name', scopes: ['source.asciidoc.properties', 'meta.value-pair.section-item.asciidoc.properties', 'punctuation.definition.entity.asciidoc.properties']
      expect(tokens[1]).toEqual value: ' ', scopes: ['source.asciidoc.properties', 'meta.value-pair.section-item.asciidoc.properties']
      expect(tokens[2]).toEqual value: '=', scopes: ['source.asciidoc.properties', 'meta.value-pair.section-item.asciidoc.properties', 'punctuation.separator.key-value.asciidoc.properties']
      expect(tokens[3]).toEqual value: ' ', scopes: ['source.asciidoc.properties', 'meta.value-pair.section-item.asciidoc.properties']
      expect(tokens[4]).toEqual value: '\\"', scopes: ['source.asciidoc.properties', 'meta.value-pair.section-item.asciidoc.properties', 'constant.character.escape.asciidoc.properties']
      expect(tokens[5]).toEqual value: 'foobar', scopes: ['source.asciidoc.properties', 'meta.value-pair.section-item.asciidoc.properties']
      expect(tokens[6]).toEqual value: '\\"', scopes: ['source.asciidoc.properties', 'meta.value-pair.section-item.asciidoc.properties', 'constant.character.escape.asciidoc.properties']
