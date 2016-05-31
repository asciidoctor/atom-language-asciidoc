describe 'General block macro', ->
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

    it 'reference a gist', ->
      {tokens} = grammar.tokenizeLine 'gist::123456[]'
      expect(tokens).toHaveLength 5
      expect(tokens[0]).toEqualJson value: 'gist', scopes: ['source.asciidoc', 'markup.macro.block.general.asciidoc', 'entity.name.function.asciidoc']
      expect(tokens[1]).toEqualJson value: '::', scopes: ['source.asciidoc', 'markup.macro.block.general.asciidoc', 'punctuation.separator.asciidoc']
      expect(tokens[2]).toEqualJson value: '123456', scopes: ['source.asciidoc', 'markup.macro.block.general.asciidoc', 'markup.link.asciidoc']
      expect(tokens[3]).toEqualJson value: '[', scopes: ['source.asciidoc', 'markup.macro.block.general.asciidoc', 'punctuation.separator.asciidoc']
      expect(tokens[4]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.macro.block.general.asciidoc', 'punctuation.separator.asciidoc']

    it 'reference an image', ->
      {tokens} = grammar.tokenizeLine 'image::filename.png[Caption]'
      expect(tokens).toHaveLength 6
      expect(tokens[0]).toEqualJson value: 'image', scopes: ['source.asciidoc', 'markup.macro.block.general.asciidoc', 'entity.name.function.asciidoc']
      expect(tokens[1]).toEqualJson value: '::', scopes: ['source.asciidoc', 'markup.macro.block.general.asciidoc', 'punctuation.separator.asciidoc']
      expect(tokens[2]).toEqualJson value: 'filename.png', scopes: ['source.asciidoc', 'markup.macro.block.general.asciidoc', 'markup.link.asciidoc']
      expect(tokens[3]).toEqualJson value: '[', scopes: ['source.asciidoc', 'markup.macro.block.general.asciidoc', 'punctuation.separator.asciidoc']
      expect(tokens[4]).toEqualJson value: 'Caption', scopes: ['source.asciidoc', 'markup.macro.block.general.asciidoc', 'string.unquoted.asciidoc']
      expect(tokens[5]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.macro.block.general.asciidoc', 'punctuation.separator.asciidoc']

    it 'reference a video', ->
      {tokens} = grammar.tokenizeLine 'video::http://youtube.com/12345[Cats vs Dogs]'
      expect(tokens).toHaveLength 6
      expect(tokens[0]).toEqualJson value: 'video', scopes: ['source.asciidoc', 'markup.macro.block.general.asciidoc', 'entity.name.function.asciidoc']
      expect(tokens[1]).toEqualJson value: '::', scopes: ['source.asciidoc', 'markup.macro.block.general.asciidoc', 'punctuation.separator.asciidoc']
      expect(tokens[2]).toEqualJson value: 'http://youtube.com/12345', scopes: ['source.asciidoc', 'markup.macro.block.general.asciidoc', 'markup.link.asciidoc']
      expect(tokens[3]).toEqualJson value: '[', scopes: ['source.asciidoc', 'markup.macro.block.general.asciidoc', 'punctuation.separator.asciidoc']
      expect(tokens[4]).toEqualJson value: 'Cats vs Dogs', scopes: ['source.asciidoc', 'markup.macro.block.general.asciidoc', 'string.unquoted.asciidoc']
      expect(tokens[5]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.macro.block.general.asciidoc', 'punctuation.separator.asciidoc']

    it 'not at the line beginning (invalid context)', ->
      {tokens} = grammar.tokenizeLine 'foo image::filename.png[Caption]'
      expect(tokens).toHaveLength 1
      expect(tokens[0]).toEqualJson value: 'foo image::filename.png[Caption]', scopes: ['source.asciidoc']
