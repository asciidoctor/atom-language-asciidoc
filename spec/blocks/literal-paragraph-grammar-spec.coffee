describe 'Literal paragraph', ->
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
        [literal]
        ....
        Daleks EXTERMINATE in monospace!
        ....
        '''

      expect(tokens).toHaveLength 4
      expect(tokens[0]).toHaveLength 3
      expect(tokens[0][0]).toEqualJson value: '[', scopes: ['source.asciidoc', 'markup.block.literal.asciidoc']
      expect(tokens[0][1]).toEqualJson value: 'literal', scopes: ['source.asciidoc', 'markup.block.literal.asciidoc', 'markup.meta.attribute-list.asciidoc', 'entity.name.function.asciidoc']
      expect(tokens[0][2]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.block.literal.asciidoc']
      expect(tokens[1]).toHaveLength 1
      expect(tokens[1][0]).toEqualJson value: '....', scopes: ['source.asciidoc', 'markup.block.literal.asciidoc']
      expect(tokens[2]).toHaveLength 1
      expect(tokens[2][0]).toEqualJson value: 'Daleks EXTERMINATE in monospace!', scopes: ['source.asciidoc', 'markup.block.literal.asciidoc']
      expect(tokens[3]).toHaveLength 1
      expect(tokens[3][0]).toEqualJson value: '....', scopes: ['source.asciidoc', 'markup.block.literal.asciidoc']

  describe 'Should not tokenizes when', ->

    it 'beginning with space', ->
      tokens = grammar.tokenizeLines '''
         [literal]
        ....
        Daleks EXTERMINATE in monospace!
        ....
        '''

      expect(tokens).toHaveLength 4
      expect(tokens[0]).toHaveLength 1
      expect(tokens[0][0]).toEqualJson value: ' [literal]', scopes: ['source.asciidoc']
      expect(tokens[1]).toHaveLength 1
      expect(tokens[1][0]).toEqualJson value: '....', scopes: ['source.asciidoc', 'markup.block.literal.asciidoc']
      expect(tokens[2]).toHaveLength 1
      expect(tokens[2][0]).toEqualJson value: 'Daleks EXTERMINATE in monospace!', scopes: ['source.asciidoc', 'markup.block.literal.asciidoc']
      expect(tokens[3]).toHaveLength 1
      expect(tokens[3][0]).toEqualJson value: '....', scopes: ['source.asciidoc', 'markup.block.literal.asciidoc']
