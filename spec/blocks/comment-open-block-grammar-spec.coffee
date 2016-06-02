describe 'Comment open block', ->
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
        [comment]
        --
        an open block comment.
        an open block comment.

        an open block comment.
        --
        foobar
        '''
      expect(tokens).toHaveLength 8
      expect(tokens[0]).toHaveLength 3
      expect(tokens[0][0]).toEqualJson value: '[', scopes: ['source.asciidoc', 'comment.block.asciidoc']
      expect(tokens[0][1]).toEqualJson value: 'comment', scopes: ['source.asciidoc', 'comment.block.asciidoc', 'markup.meta.attribute-list.asciidoc', 'entity.name.function.asciidoc']
      expect(tokens[0][2]).toEqualJson value: ']', scopes: ['source.asciidoc', 'comment.block.asciidoc']
      expect(tokens[1]).toHaveLength 1
      expect(tokens[1][0]).toEqualJson value: '--', scopes: ['source.asciidoc', 'comment.block.asciidoc']
      expect(tokens[2]).toHaveLength 1
      expect(tokens[2][0]).toEqualJson value: 'an open block comment.', scopes: ['source.asciidoc', 'comment.block.asciidoc']
      expect(tokens[3]).toHaveLength 1
      expect(tokens[3][0]).toEqualJson value: 'an open block comment.', scopes: ['source.asciidoc', 'comment.block.asciidoc']
      expect(tokens[4]).toHaveLength 1
      expect(tokens[4][0]).toEqualJson value: '', scopes: ['source.asciidoc', 'comment.block.asciidoc']
      expect(tokens[5]).toHaveLength 1
      expect(tokens[5][0]).toEqualJson value: 'an open block comment.', scopes: ['source.asciidoc', 'comment.block.asciidoc']
      expect(tokens[6]).toHaveLength 2
      expect(tokens[6][0]).toEqualJson value: '--', scopes: ['source.asciidoc', 'comment.block.asciidoc']
      expect(tokens[6][1]).toEqualJson value: '', scopes: ['source.asciidoc', 'comment.block.asciidoc']
      expect(tokens[7]).toHaveLength 1
      expect(tokens[7][0]).toEqualJson value: 'foobar', scopes: ['source.asciidoc']
