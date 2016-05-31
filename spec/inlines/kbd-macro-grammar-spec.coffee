describe 'Keyboard macro', ->
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

    it 'simple key', ->
      {tokens} = grammar.tokenizeLine 'foo kbd:[F3] bar'
      expect(tokens).toHaveLength 6
      expect(tokens[0]).toEqualJson value: 'foo ', scopes: ['source.asciidoc']
      expect(tokens[1]).toEqualJson value: 'kbd', scopes: ['source.asciidoc', 'markup.macro.kbd.asciidoc', 'entity.name.function.asciidoc']
      expect(tokens[2]).toEqualJson value: ':[', scopes: ['source.asciidoc', 'markup.macro.kbd.asciidoc']
      expect(tokens[3]).toEqualJson value: 'F3', scopes: ['source.asciidoc', 'markup.macro.kbd.asciidoc', 'string.unquoted.asciidoc']
      expect(tokens[4]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.macro.kbd.asciidoc']
      expect(tokens[5]).toEqualJson value: ' bar', scopes: ['source.asciidoc']

    it 'several keys', ->
      {tokens} = grammar.tokenizeLine 'foo kbd:[Ctrl+Shift+T] bar'
      expect(tokens).toHaveLength 6
      expect(tokens[0]).toEqualJson value: 'foo ', scopes: ['source.asciidoc']
      expect(tokens[1]).toEqualJson value: 'kbd', scopes: ['source.asciidoc', 'markup.macro.kbd.asciidoc', 'entity.name.function.asciidoc']
      expect(tokens[2]).toEqualJson value: ':[', scopes: ['source.asciidoc', 'markup.macro.kbd.asciidoc']
      expect(tokens[3]).toEqualJson value: 'Ctrl+Shift+T', scopes: ['source.asciidoc', 'markup.macro.kbd.asciidoc', 'string.unquoted.asciidoc']
      expect(tokens[4]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.macro.kbd.asciidoc']
      expect(tokens[5]).toEqualJson value: ' bar', scopes: ['source.asciidoc']

    it 'contains ]', ->
      {tokens} = grammar.tokenizeLine 'foo kbd:[Ctrl+\]] bar'
      expect(tokens).toHaveLength 6
      expect(tokens[0]).toEqualJson value: 'foo ', scopes: ['source.asciidoc']
      expect(tokens[1]).toEqualJson value: 'kbd', scopes: ['source.asciidoc', 'markup.macro.kbd.asciidoc', 'entity.name.function.asciidoc']
      expect(tokens[2]).toEqualJson value: ':[', scopes: ['source.asciidoc', 'markup.macro.kbd.asciidoc']
      expect(tokens[3]).toEqualJson value: 'Ctrl+', scopes: ['source.asciidoc', 'markup.macro.kbd.asciidoc', 'string.unquoted.asciidoc']
      expect(tokens[4]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.macro.kbd.asciidoc']
      expect(tokens[5]).toEqualJson value: '] bar', scopes: ['source.asciidoc']

    it 'contains a label', ->
      {tokens} = grammar.tokenizeLine 'foo btn:[Save] bar'
      expect(tokens).toHaveLength 6
      expect(tokens[0]).toEqualJson value: 'foo ', scopes: ['source.asciidoc']
      expect(tokens[1]).toEqualJson value: 'btn', scopes: ['source.asciidoc', 'markup.macro.kbd.asciidoc', 'entity.name.function.asciidoc']
      expect(tokens[2]).toEqualJson value: ':[', scopes: ['source.asciidoc', 'markup.macro.kbd.asciidoc']
      expect(tokens[3]).toEqualJson value: 'Save', scopes: ['source.asciidoc', 'markup.macro.kbd.asciidoc', 'string.unquoted.asciidoc']
      expect(tokens[4]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.macro.kbd.asciidoc']
      expect(tokens[5]).toEqualJson value: ' bar', scopes: ['source.asciidoc']
