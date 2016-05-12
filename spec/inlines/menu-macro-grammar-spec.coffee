describe 'Should tokenizes menu macro when', ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage 'language-asciidoc'

    runs ->
      grammar = atom.grammars.grammarForScopeName 'source.asciidoc'

  # convenience function during development
  debug = (tokens) ->
    console.log(JSON.stringify tokens, null, ' ')

  it 'parses the grammar', ->
    expect(grammar).toBeDefined()
    expect(grammar.scopeName).toBe 'source.asciidoc'

  it 'contains File item', ->
    {tokens} = grammar.tokenizeLine 'menu:File[New...]'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqualJson value: 'menu:', scopes: ['source.asciidoc', 'markup.link.menu.asciidoc']
    expect(tokens[1]).toEqualJson value: 'File', scopes: ['source.asciidoc', 'markup.link.menu.asciidoc', 'support.constant.asciidoc']
    expect(tokens[2]).toEqualJson value: '[New...]', scopes: ['source.asciidoc', 'markup.link.menu.asciidoc']

  it 'contains View item', ->
    {tokens} = grammar.tokenizeLine 'menu:View[Page Style > No Style]'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqualJson value: 'menu:', scopes: ['source.asciidoc', 'markup.link.menu.asciidoc']
    expect(tokens[1]).toEqualJson value: 'View', scopes: ['source.asciidoc', 'markup.link.menu.asciidoc', 'support.constant.asciidoc']
    expect(tokens[2]).toEqualJson value: '[Page Style > No Style]', scopes: ['source.asciidoc', 'markup.link.menu.asciidoc']

  it 'contains View item comma', ->
    {tokens} = grammar.tokenizeLine 'menu:View[Page Style, No Style]'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqualJson value: 'menu:', scopes: ['source.asciidoc', 'markup.link.menu.asciidoc']
    expect(tokens[1]).toEqualJson value: 'View', scopes: ['source.asciidoc', 'markup.link.menu.asciidoc', 'support.constant.asciidoc']
    expect(tokens[2]).toEqualJson value: '[Page Style, No Style]', scopes: ['source.asciidoc', 'markup.link.menu.asciidoc']
