describe 'Menu macro', ->
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

    it 'contains File item', ->
      {tokens} = grammar.tokenizeLine 'menu:File[New...]'
      expect(tokens).toHaveLength 6
      expect(tokens[0]).toEqualJson value: 'menu', scopes: ['source.asciidoc', 'markup.other.menu.asciidoc', 'entity.name.function.asciidoc']
      expect(tokens[1]).toEqualJson value: ':', scopes: ['source.asciidoc', 'markup.other.menu.asciidoc']
      expect(tokens[2]).toEqualJson value: 'File', scopes: ['source.asciidoc', 'markup.other.menu.asciidoc', 'markup.link.asciidoc']
      expect(tokens[3]).toEqualJson value: '[', scopes: ['source.asciidoc', 'markup.other.menu.asciidoc']
      expect(tokens[4]).toEqualJson value: 'New...', scopes: ['source.asciidoc', 'markup.other.menu.asciidoc', 'string.unquoted.asciidoc']
      expect(tokens[5]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.other.menu.asciidoc']

    it 'contains View item', ->
      {tokens} = grammar.tokenizeLine 'menu:View[Page Style > No Style]'
      expect(tokens).toHaveLength 6
      expect(tokens[0]).toEqualJson value: 'menu', scopes: ['source.asciidoc', 'markup.other.menu.asciidoc', 'entity.name.function.asciidoc']
      expect(tokens[1]).toEqualJson value: ':', scopes: ['source.asciidoc', 'markup.other.menu.asciidoc']
      expect(tokens[2]).toEqualJson value: 'View', scopes: ['source.asciidoc', 'markup.other.menu.asciidoc', 'markup.link.asciidoc']
      expect(tokens[3]).toEqualJson value: '[', scopes: ['source.asciidoc', 'markup.other.menu.asciidoc']
      expect(tokens[4]).toEqualJson value: 'Page Style > No Style', scopes: ['source.asciidoc', 'markup.other.menu.asciidoc', 'string.unquoted.asciidoc']
      expect(tokens[5]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.other.menu.asciidoc']

    it 'contains View item comma', ->
      {tokens} = grammar.tokenizeLine 'menu:View[Page Style, No Style]'
      expect(tokens).toHaveLength 6
      expect(tokens[0]).toEqualJson value: 'menu', scopes: ['source.asciidoc', 'markup.other.menu.asciidoc', 'entity.name.function.asciidoc']
      expect(tokens[1]).toEqualJson value: ':', scopes: ['source.asciidoc', 'markup.other.menu.asciidoc']
      expect(tokens[2]).toEqualJson value: 'View', scopes: ['source.asciidoc', 'markup.other.menu.asciidoc', 'markup.link.asciidoc']
      expect(tokens[3]).toEqualJson value: '[', scopes: ['source.asciidoc', 'markup.other.menu.asciidoc']
      expect(tokens[4]).toEqualJson value: 'Page Style, No Style', scopes: ['source.asciidoc', 'markup.other.menu.asciidoc', 'string.unquoted.asciidoc']
      expect(tokens[5]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.other.menu.asciidoc']
