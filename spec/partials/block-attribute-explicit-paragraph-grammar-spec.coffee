describe 'Should tokenizes block attribute for explicit paragraph when', ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage 'language-asciidoc'

    runs ->
      grammar = atom.grammars.grammarForScopeName 'source.asciidoc'

  it 'parses the grammar', ->
    expect(grammar).toBeDefined()
    expect(grammar.scopeName).toBe 'source.asciidoc'

  it 'use "normal" keyword', ->
    {tokens} = grammar.tokenizeLine '[normal]'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqualJson value: '[', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc']
    expect(tokens[1]).toEqualJson value: 'normal', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc', 'markup.meta.attribute-list.asciidoc', 'entity.name.function.asciidoc']
    expect(tokens[2]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc']

  it 'use "literal" keyword', ->
    {tokens} = grammar.tokenizeLine '[literal]'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqualJson value: '[', scopes: ['source.asciidoc', 'markup.block.literal.asciidoc']
    expect(tokens[1]).toEqualJson value: 'literal', scopes: ['source.asciidoc', 'markup.block.literal.asciidoc', 'markup.meta.attribute-list.asciidoc', 'entity.name.function.asciidoc']
    expect(tokens[2]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.block.literal.asciidoc']

  it 'use "listing" keyword', ->
    {tokens} = grammar.tokenizeLine '[listing]'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqualJson value: '[', scopes: ['source.asciidoc', 'markup.block.listing.asciidoc']
    expect(tokens[1]).toEqualJson value: 'listing', scopes: ['source.asciidoc', 'markup.block.listing.asciidoc', 'markup.meta.attribute-list.asciidoc', 'entity.name.function.asciidoc']
    expect(tokens[2]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.block.listing.asciidoc']

  it 'use "TIP" keyword', ->
    {tokens} = grammar.tokenizeLine '[TIP]'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqualJson value: '[', scopes: ['source.asciidoc', 'markup.admonition.asciidoc']
    expect(tokens[1]).toEqualJson value: 'TIP', scopes: ['source.asciidoc', 'markup.admonition.asciidoc', 'markup.meta.attribute-list.asciidoc', 'entity.name.function.asciidoc']
    expect(tokens[2]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.admonition.asciidoc']

  it 'use "NOTE" keyword', ->
    {tokens} = grammar.tokenizeLine '[NOTE]'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqualJson value: '[', scopes: ['source.asciidoc', 'markup.admonition.asciidoc']
    expect(tokens[1]).toEqualJson value: 'NOTE', scopes: ['source.asciidoc', 'markup.admonition.asciidoc', 'markup.meta.attribute-list.asciidoc', 'entity.name.function.asciidoc']
    expect(tokens[2]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.admonition.asciidoc']

  it 'use "IMPORTANT" keyword', ->
    {tokens} = grammar.tokenizeLine '[IMPORTANT]'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqualJson value: '[', scopes: ['source.asciidoc', 'markup.admonition.asciidoc']
    expect(tokens[1]).toEqualJson value: 'IMPORTANT', scopes: ['source.asciidoc', 'markup.admonition.asciidoc', 'markup.meta.attribute-list.asciidoc', 'entity.name.function.asciidoc']
    expect(tokens[2]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.admonition.asciidoc']

  it 'use "WARNING" keyword', ->
    {tokens} = grammar.tokenizeLine '[WARNING]'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqualJson value: '[', scopes: ['source.asciidoc', 'markup.admonition.asciidoc']
    expect(tokens[1]).toEqualJson value: 'WARNING', scopes: ['source.asciidoc', 'markup.admonition.asciidoc', 'markup.meta.attribute-list.asciidoc', 'entity.name.function.asciidoc']
    expect(tokens[2]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.admonition.asciidoc']

  it 'use "CAUTION" keyword', ->
    {tokens} = grammar.tokenizeLine '[CAUTION]'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqualJson value: '[', scopes: ['source.asciidoc', 'markup.admonition.asciidoc']
    expect(tokens[1]).toEqualJson value: 'CAUTION', scopes: ['source.asciidoc', 'markup.admonition.asciidoc', 'markup.meta.attribute-list.asciidoc', 'entity.name.function.asciidoc']
    expect(tokens[2]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.admonition.asciidoc']

  it 'use "partintro" keyword', ->
    {tokens} = grammar.tokenizeLine '[partintro]'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqualJson value: '[', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc']
    expect(tokens[1]).toEqualJson value: 'partintro', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc', 'markup.meta.attribute-list.asciidoc', 'entity.name.function.asciidoc']
    expect(tokens[2]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc']

  it 'use "comment" keyword', ->
    {tokens} = grammar.tokenizeLine '[comment]'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqualJson value: '[', scopes: ['source.asciidoc', 'comment.block.asciidoc']
    expect(tokens[1]).toEqualJson value: 'comment', scopes: ['source.asciidoc', 'comment.block.asciidoc', 'markup.meta.attribute-list.asciidoc', 'entity.name.function.asciidoc']
    expect(tokens[2]).toEqualJson value: ']', scopes: ['source.asciidoc', 'comment.block.asciidoc']

  it 'use "example" keyword', ->
    {tokens} = grammar.tokenizeLine '[example]'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqualJson value: '[', scopes: ['source.asciidoc', 'markup.block.example.asciidoc']
    expect(tokens[1]).toEqualJson value: 'example', scopes: ['source.asciidoc', 'markup.block.example.asciidoc', 'markup.meta.attribute-list.asciidoc', 'entity.name.function.asciidoc']
    expect(tokens[2]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.block.example.asciidoc']

  it 'use "sidebar" keyword', ->
    {tokens} = grammar.tokenizeLine '[sidebar]'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqualJson value: '[', scopes: ['source.asciidoc', 'markup.block.sidebar.asciidoc']
    expect(tokens[1]).toEqualJson value: 'sidebar', scopes: ['source.asciidoc', 'markup.block.sidebar.asciidoc', 'markup.meta.attribute-list.asciidoc', 'entity.name.function.asciidoc']
    expect(tokens[2]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.block.sidebar.asciidoc']

  it 'use "source" keyword', ->
    {tokens} = grammar.tokenizeLine '[source]'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqualJson value: '[', scopes: ['source.asciidoc', 'markup.heading.asciidoc']
    expect(tokens[1]).toEqualJson value: 'source', scopes: ['source.asciidoc', 'markup.heading.asciidoc', 'markup.meta.attribute-list.asciidoc', 'entity.name.function.asciidoc']
    expect(tokens[2]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.heading.asciidoc']

  it 'use "music" keyword', ->
    {tokens} = grammar.tokenizeLine '[music]'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqualJson value: '[', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc']
    expect(tokens[1]).toEqualJson value: 'music', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc', 'markup.meta.attribute-list.asciidoc', 'entity.name.function.asciidoc']
    expect(tokens[2]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc']

  it 'use "latex" keyword', ->
    {tokens} = grammar.tokenizeLine '[latex]'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqualJson value: '[', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc']
    expect(tokens[1]).toEqualJson value: 'latex', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc', 'markup.meta.attribute-list.asciidoc', 'entity.name.function.asciidoc']
    expect(tokens[2]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc']

  it 'use "graphviz" keyword', ->
    {tokens} = grammar.tokenizeLine '[graphviz]'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqualJson value: '[', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc']
    expect(tokens[1]).toEqualJson value: 'graphviz', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc', 'markup.meta.attribute-list.asciidoc', 'entity.name.function.asciidoc']
    expect(tokens[2]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.heading.block-attribute.asciidoc']
