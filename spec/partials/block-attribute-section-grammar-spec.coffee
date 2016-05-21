describe 'Should tokenizes block attribute for section title when', ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage 'language-asciidoc'

    runs ->
      grammar = atom.grammars.grammarForScopeName 'source.asciidoc'

  it 'parses the grammar', ->
    expect(grammar).toBeDefined()
    expect(grammar.scopeName).toBe 'source.asciidoc'

  it 'use "abstract" keyword', ->
    {tokens} = grammar.tokenizeLine '[abstract]'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqualJson value: '[', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc']
    expect(tokens[1]).toEqualJson value: 'abstract', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc', 'markup.meta.attribute-list.asciidoc', 'entity.name.function.asciidoc']
    expect(tokens[2]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc']

  it 'use "preface" keyword', ->
    {tokens} = grammar.tokenizeLine '[preface]'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqualJson value: '[', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc']
    expect(tokens[1]).toEqualJson value: 'preface', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc', 'markup.meta.attribute-list.asciidoc', 'entity.name.function.asciidoc']
    expect(tokens[2]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc']

  it 'use "colophon" keyword', ->
    {tokens} = grammar.tokenizeLine '[colophon]'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqualJson value: '[', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc']
    expect(tokens[1]).toEqualJson value: 'colophon', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc', 'markup.meta.attribute-list.asciidoc', 'entity.name.function.asciidoc']
    expect(tokens[2]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc']

  it 'use "dedication" keyword', ->
    {tokens} = grammar.tokenizeLine '[dedication]'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqualJson value: '[', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc']
    expect(tokens[1]).toEqualJson value: 'dedication', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc', 'markup.meta.attribute-list.asciidoc', 'entity.name.function.asciidoc']
    expect(tokens[2]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc']

  it 'use "glossary" keyword', ->
    {tokens} = grammar.tokenizeLine '[glossary]'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqualJson value: '[', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc']
    expect(tokens[1]).toEqualJson value: 'glossary', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc', 'markup.meta.attribute-list.asciidoc', 'entity.name.function.asciidoc']
    expect(tokens[2]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc']

  it 'use "bibliography" keyword', ->
    {tokens} = grammar.tokenizeLine '[bibliography]'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqualJson value: '[', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc']
    expect(tokens[1]).toEqualJson value: 'bibliography', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc', 'markup.meta.attribute-list.asciidoc', 'entity.name.function.asciidoc']
    expect(tokens[2]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc']

  it 'use "synopsis" keyword', ->
    {tokens} = grammar.tokenizeLine '[synopsis]'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqualJson value: '[', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc']
    expect(tokens[1]).toEqualJson value: 'synopsis', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc', 'markup.meta.attribute-list.asciidoc', 'entity.name.function.asciidoc']
    expect(tokens[2]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc']

  it 'use "appendix" keyword', ->
    {tokens} = grammar.tokenizeLine '[appendix]'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqualJson value: '[', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc']
    expect(tokens[1]).toEqualJson value: 'appendix', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc', 'markup.meta.attribute-list.asciidoc', 'entity.name.function.asciidoc']
    expect(tokens[2]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc']

  it 'use "index" keyword', ->
    {tokens} = grammar.tokenizeLine '[index]'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqualJson value: '[', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc']
    expect(tokens[1]).toEqualJson value: 'index', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc', 'markup.meta.attribute-list.asciidoc', 'entity.name.function.asciidoc']
    expect(tokens[2]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc']

  it 'use "sect1" keyword', ->
    {tokens} = grammar.tokenizeLine '[sect1]'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqualJson value: '[', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc']
    expect(tokens[1]).toEqualJson value: 'sect1', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc', 'markup.meta.attribute-list.asciidoc', 'entity.name.function.asciidoc']
    expect(tokens[2]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc']

  it 'use "sect2" keyword', ->
    {tokens} = grammar.tokenizeLine '[sect2]'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqualJson value: '[', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc']
    expect(tokens[1]).toEqualJson value: 'sect2', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc', 'markup.meta.attribute-list.asciidoc', 'entity.name.function.asciidoc']
    expect(tokens[2]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc']

  it 'use "sect3" keyword', ->
    {tokens} = grammar.tokenizeLine '[sect3]'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqualJson value: '[', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc']
    expect(tokens[1]).toEqualJson value: 'sect3', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc', 'markup.meta.attribute-list.asciidoc', 'entity.name.function.asciidoc']
    expect(tokens[2]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc']

  it 'use "sect4" keyword', ->
    {tokens} = grammar.tokenizeLine '[sect4]'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqualJson value: '[', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc']
    expect(tokens[1]).toEqualJson value: 'sect4', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc', 'markup.meta.attribute-list.asciidoc', 'entity.name.function.asciidoc']
    expect(tokens[2]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc']


  it 'simple section with text', ->
    tokens = grammar.tokenizeLines '''
      [sect1]
      This is an section.
      '''
    expect(tokens).toHaveLength 2
    expect(tokens[0]).toHaveLength 3
    expect(tokens[0][0]).toEqualJson value: '[', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc']
    expect(tokens[0][1]).toEqualJson value: 'sect1', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc', 'markup.meta.attribute-list.asciidoc', 'entity.name.function.asciidoc']
    expect(tokens[0][2]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc']
    expect(tokens[1]).toHaveLength 1
    expect(tokens[1][0]).toEqualJson value: 'This is an section.', scopes: ['source.asciidoc']











#
