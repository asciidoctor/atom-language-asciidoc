describe 'Passthrough block', ->
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

    it 'contains simple phrase', ->
      tokens = grammar.tokenizeLines '''
        ++++
        <s>Could be struck through</s>
        ++++
        foobar
        '''
      expect(tokens).toHaveLength 4
      expect(tokens[0]).toHaveLength 1
      expect(tokens[0][0]).toEqualJson value: '++++', scopes: ['source.asciidoc', 'markup.block.passthrough.asciidoc']
      expect(tokens[1]).toHaveLength 1
      expect(tokens[1][0]).toEqualJson value: '<s>Could be struck through</s>', scopes: ['source.asciidoc', 'markup.block.passthrough.asciidoc']
      expect(tokens[2]).toHaveLength 1
      expect(tokens[2][0]).toEqualJson value: '++++', scopes: ['source.asciidoc', 'markup.block.passthrough.asciidoc']
      expect(tokens[3]).toHaveLength 1
      expect(tokens[3][0]).toEqualJson value: 'foobar', scopes: ['source.asciidoc']

    it 'contains simple phrase with block name', ->
      tokens = grammar.tokenizeLines '''
        [pass]
        ++++
        <s>Could be struck through</s>
        ++++
        foobar
        '''
      expect(tokens).toHaveLength 5
      expect(tokens[0]).toHaveLength 3
      expect(tokens[0][0]).toEqualJson value: '[', scopes: ['source.asciidoc', 'markup.block.passthrough.asciidoc', 'markup.heading.asciidoc']
      expect(tokens[0][1]).toEqualJson value: 'pass', scopes: ['source.asciidoc', 'markup.block.passthrough.asciidoc', 'markup.heading.asciidoc', 'markup.meta.attribute-list.asciidoc', 'entity.name.function.asciidoc']
      expect(tokens[0][2]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.block.passthrough.asciidoc', 'markup.heading.asciidoc']
      expect(tokens[1]).toHaveLength 1
      expect(tokens[1][0]).toEqualJson value: '++++', scopes: ['source.asciidoc', 'markup.block.passthrough.asciidoc']
      expect(tokens[2]).toHaveLength 1
      expect(tokens[2][0]).toEqualJson value: '<s>Could be struck through</s>', scopes: ['source.asciidoc', 'markup.block.passthrough.asciidoc']
      expect(tokens[3]).toHaveLength 2
      expect(tokens[3][0]).toEqualJson value: '++++', scopes: ['source.asciidoc', 'markup.block.passthrough.asciidoc']
      expect(tokens[3][1]).toEqualJson value: '', scopes: ['source.asciidoc', 'markup.block.passthrough.asciidoc']
      expect(tokens[4]).toHaveLength 1
      expect(tokens[4][0]).toEqualJson value: 'foobar', scopes: ['source.asciidoc']
