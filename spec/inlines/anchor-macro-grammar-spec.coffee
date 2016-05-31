describe 'Anchor macro', ->
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

    it 'simple anchor', ->
      {tokens} = grammar.tokenizeLine 'foo [[idname]] bar'
      expect(tokens).toHaveLength 5
      expect(tokens[0]).toEqualJson value: 'foo ', scopes: ['source.asciidoc']
      expect(tokens[1]).toEqualJson value: '[[', scopes: ['source.asciidoc', 'markup.other.anchor.asciidoc', 'support.constant.asciidoc']
      expect(tokens[2]).toEqualJson value: 'idname', scopes: ['source.asciidoc', 'markup.other.anchor.asciidoc', 'markup.blockid.asciidoc']
      expect(tokens[3]).toEqualJson value: ']]', scopes: ['source.asciidoc', 'markup.other.anchor.asciidoc', 'support.constant.asciidoc']
      expect(tokens[4]).toEqualJson value: ' bar', scopes: ['source.asciidoc']

    it 'extends anchor', ->
      {tokens} = grammar.tokenizeLine 'foo [[idname,Reference Text]] bar'
      expect(tokens).toHaveLength 7
      expect(tokens[0]).toEqualJson value: 'foo ', scopes: ['source.asciidoc']
      expect(tokens[1]).toEqualJson value: '[[', scopes: ['source.asciidoc', 'markup.other.anchor.asciidoc', 'support.constant.asciidoc']
      expect(tokens[2]).toEqualJson value: 'idname', scopes: ['source.asciidoc', 'markup.other.anchor.asciidoc', 'markup.blockid.asciidoc']
      expect(tokens[3]).toEqualJson value: ',', scopes: ['source.asciidoc', 'markup.other.anchor.asciidoc']
      expect(tokens[4]).toEqualJson value: 'Reference Text', scopes: ['source.asciidoc', 'markup.other.anchor.asciidoc', 'string.unquoted.asciidoc']
      expect(tokens[5]).toEqualJson value: ']]', scopes: ['source.asciidoc', 'markup.other.anchor.asciidoc', 'support.constant.asciidoc']
      expect(tokens[6]).toEqualJson value: ' bar', scopes: ['source.asciidoc']

    it 'simple anchor macro', ->
      {tokens} = grammar.tokenizeLine 'foo anchor:idname[] bar'
      expect(tokens).toHaveLength 6
      expect(tokens[0]).toEqualJson value: 'foo ', scopes: ['source.asciidoc']
      expect(tokens[1]).toEqualJson value: 'anchor', scopes: ['source.asciidoc', 'markup.other.anchor.asciidoc', 'entity.name.function.asciidoc']
      expect(tokens[2]).toEqualJson value: ':', scopes: ['source.asciidoc', 'markup.other.anchor.asciidoc']
      expect(tokens[3]).toEqualJson value: 'idname', scopes: ['source.asciidoc', 'markup.other.anchor.asciidoc', 'markup.blockid.asciidoc']
      expect(tokens[4]).toEqualJson value: '[]', scopes: ['source.asciidoc', 'markup.other.anchor.asciidoc']
      expect(tokens[5]).toEqualJson value: ' bar', scopes: ['source.asciidoc']

    it 'extends anchor macro', ->
      {tokens} = grammar.tokenizeLine 'foo anchor:idname[Reference Text] bar'
      expect(tokens).toHaveLength 8
      expect(tokens[0]).toEqualJson value: 'foo ', scopes: ['source.asciidoc']
      expect(tokens[1]).toEqualJson value: 'anchor', scopes: ['source.asciidoc', 'markup.other.anchor.asciidoc', 'entity.name.function.asciidoc']
      expect(tokens[2]).toEqualJson value: ':', scopes: ['source.asciidoc', 'markup.other.anchor.asciidoc']
      expect(tokens[3]).toEqualJson value: 'idname', scopes: ['source.asciidoc', 'markup.other.anchor.asciidoc', 'markup.blockid.asciidoc']
      expect(tokens[4]).toEqualJson value: '[', scopes: ['source.asciidoc', 'markup.other.anchor.asciidoc']
      expect(tokens[5]).toEqualJson value: 'Reference Text', scopes: ['source.asciidoc', 'markup.other.anchor.asciidoc', 'string.unquoted.asciidoc']
      expect(tokens[6]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.other.anchor.asciidoc']
      expect(tokens[7]).toEqualJson value: ' bar', scopes: ['source.asciidoc']
