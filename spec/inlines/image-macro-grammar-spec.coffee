describe 'Image/icon macro', ->
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

    it 'reference a relative path to an image', ->
      {tokens} = grammar.tokenizeLine 'foo image:filename.png[Alt Text] bar'
      expect(tokens).toHaveLength 8
      expect(tokens[0]).toEqualJson value: 'foo ', scopes: ['source.asciidoc']
      expect(tokens[1]).toEqualJson value: 'image', scopes: ['source.asciidoc', 'markup.macro.image.asciidoc', 'entity.name.function.asciidoc']
      expect(tokens[2]).toEqualJson value: ':', scopes: ['source.asciidoc', 'markup.macro.image.asciidoc']
      expect(tokens[3]).toEqualJson value: 'filename.png', scopes: ['source.asciidoc', 'markup.macro.image.asciidoc', 'markup.link.asciidoc']
      expect(tokens[4]).toEqualJson value: '[', scopes: ['source.asciidoc', 'markup.macro.image.asciidoc']
      expect(tokens[5]).toEqualJson value: 'Alt Text', scopes: ['source.asciidoc', 'markup.macro.image.asciidoc', 'string.unquoted.asciidoc']
      expect(tokens[6]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.macro.image.asciidoc']
      expect(tokens[7]).toEqualJson value: ' bar', scopes: ['source.asciidoc']

    it 'reference a url to an image', ->
      {tokens} = grammar.tokenizeLine 'foo image:http://example.com/images/filename.png[Alt Text] bar'
      expect(tokens).toHaveLength 8
      expect(tokens[0]).toEqualJson value: 'foo ', scopes: ['source.asciidoc']
      expect(tokens[1]).toEqualJson value: 'image', scopes: ['source.asciidoc', 'markup.macro.image.asciidoc', 'entity.name.function.asciidoc']
      expect(tokens[2]).toEqualJson value: ':', scopes: ['source.asciidoc', 'markup.macro.image.asciidoc']
      expect(tokens[3]).toEqualJson value: 'http://example.com/images/filename.png', scopes: ['source.asciidoc', 'markup.macro.image.asciidoc', 'markup.link.asciidoc']
      expect(tokens[4]).toEqualJson value: '[', scopes: ['source.asciidoc', 'markup.macro.image.asciidoc']
      expect(tokens[5]).toEqualJson value: 'Alt Text', scopes: ['source.asciidoc', 'markup.macro.image.asciidoc', 'string.unquoted.asciidoc']
      expect(tokens[6]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.macro.image.asciidoc']
      expect(tokens[7]).toEqualJson value: ' bar', scopes: ['source.asciidoc']

    it 'reference an icon', ->
      {tokens} = grammar.tokenizeLine 'foo icon:github[large] bar'
      expect(tokens).toHaveLength 8
      expect(tokens[0]).toEqualJson value: 'foo ', scopes: ['source.asciidoc']
      expect(tokens[1]).toEqualJson value: 'icon', scopes: ['source.asciidoc', 'markup.macro.image.asciidoc', 'entity.name.function.asciidoc']
      expect(tokens[2]).toEqualJson value: ':', scopes: ['source.asciidoc', 'markup.macro.image.asciidoc']
      expect(tokens[3]).toEqualJson value: 'github', scopes: ['source.asciidoc', 'markup.macro.image.asciidoc', 'markup.link.asciidoc']
      expect(tokens[4]).toEqualJson value: '[', scopes: ['source.asciidoc', 'markup.macro.image.asciidoc']
      expect(tokens[5]).toEqualJson value: 'large', scopes: ['source.asciidoc', 'markup.macro.image.asciidoc', 'string.unquoted.asciidoc']
      expect(tokens[6]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.macro.image.asciidoc']
      expect(tokens[7]).toEqualJson value: ' bar', scopes: ['source.asciidoc']
