describe 'Should tokenizes block attribute when', ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage 'language-asciidoc'

    runs ->
      grammar = atom.grammars.grammarForScopeName 'source.asciidoc'

  it 'parses the grammar', ->
    expect(grammar).toBeDefined()
    expect(grammar.scopeName).toBe 'source.asciidoc'

  it 'contains many attributes', ->
    {tokens} = grammar.tokenizeLine '[foo, aaa, bbb, ccc, ddd, eee]'
    expect(tokens).toHaveLength 13
    i = 0
    expect(tokens[i++]).toEqualJson value: '[', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc']
    expect(tokens[i++]).toEqualJson value: 'foo', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc', 'markup.meta.attribute-list.asciidoc']
    expect(tokens[i++]).toEqualJson value: ',', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc', 'punctuation.separator.asciidoc']
    expect(tokens[i++]).toEqualJson value: ' aaa', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc', 'markup.meta.attribute-list.asciidoc']
    expect(tokens[i++]).toEqualJson value: ',', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc', 'punctuation.separator.asciidoc']
    expect(tokens[i++]).toEqualJson value: ' bbb', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc', 'markup.meta.attribute-list.asciidoc']
    expect(tokens[i++]).toEqualJson value: ',', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc', 'punctuation.separator.asciidoc']
    expect(tokens[i++]).toEqualJson value: ' ccc', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc', 'markup.meta.attribute-list.asciidoc']
    expect(tokens[i++]).toEqualJson value: ',', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc', 'punctuation.separator.asciidoc']
    expect(tokens[i++]).toEqualJson value: ' ddd', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc', 'markup.meta.attribute-list.asciidoc']
    expect(tokens[i++]).toEqualJson value: ',', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc', 'punctuation.separator.asciidoc']
    expect(tokens[i++]).toEqualJson value: ' eee', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc', 'markup.meta.attribute-list.asciidoc']
    expect(tokens[i++]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc']
    expect(i).toBe 13

  it 'contains keyword', ->
    {tokens} = grammar.tokenizeLine '[appendix, aaa, bbb, ccc, ddd, eee]'
    expect(tokens).toHaveLength 13
    i = 0
    expect(tokens[i++]).toEqualJson value: '[', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc']
    expect(tokens[i++]).toEqualJson value: 'appendix', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc', 'markup.meta.attribute-list.asciidoc', 'entity.name.function.asciidoc']
    expect(tokens[i++]).toEqualJson value: ',', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc', 'punctuation.separator.asciidoc']
    expect(tokens[i++]).toEqualJson value: ' aaa', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc', 'markup.meta.attribute-list.asciidoc']
    expect(tokens[i++]).toEqualJson value: ',', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc', 'punctuation.separator.asciidoc']
    expect(tokens[i++]).toEqualJson value: ' bbb', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc', 'markup.meta.attribute-list.asciidoc']
    expect(tokens[i++]).toEqualJson value: ',', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc', 'punctuation.separator.asciidoc']
    expect(tokens[i++]).toEqualJson value: ' ccc', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc', 'markup.meta.attribute-list.asciidoc']
    expect(tokens[i++]).toEqualJson value: ',', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc', 'punctuation.separator.asciidoc']
    expect(tokens[i++]).toEqualJson value: ' ddd', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc', 'markup.meta.attribute-list.asciidoc']
    expect(tokens[i++]).toEqualJson value: ',', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc', 'punctuation.separator.asciidoc']
    expect(tokens[i++]).toEqualJson value: ' eee', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc', 'markup.meta.attribute-list.asciidoc']
    expect(tokens[i++]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc']
    expect(i).toBe 13
