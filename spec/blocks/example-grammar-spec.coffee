describe 'Example block', ->
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

    it 'contains others grammars', ->
      tokens = grammar.tokenizeLines '''
        ====
        A multi-line *example*.

        Notice it's a _delimited_ block.
        ====
        '''
      expect(tokens).toHaveLength 5
      expect(tokens[0]).toHaveLength 1
      expect(tokens[0][0]).toEqualJson value: '====', scopes: ['source.asciidoc', 'markup.block.example.asciidoc']
      expect(tokens[1]).toHaveLength 5
      expect(tokens[1][0]).toEqualJson value: 'A multi-line ', scopes: ['source.asciidoc', 'markup.block.example.asciidoc']
      expect(tokens[1][1]).toEqualJson value: '*', scopes: ['source.asciidoc', 'markup.block.example.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[1][2]).toEqualJson value: 'example', scopes: ['source.asciidoc', 'markup.block.example.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc']
      expect(tokens[1][3]).toEqualJson value: '*', scopes: ['source.asciidoc', 'markup.block.example.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[1][4]).toEqualJson value: '.', scopes: ['source.asciidoc', 'markup.block.example.asciidoc']
      expect(tokens[2]).toHaveLength 1
      expect(tokens[2][0]).toEqualJson value: '', scopes: ['source.asciidoc', 'markup.block.example.asciidoc']
      expect(tokens[3]).toHaveLength 5
      expect(tokens[3][0]).toEqualJson value: 'Notice it\'s a ', scopes: ['source.asciidoc', 'markup.block.example.asciidoc']
      expect(tokens[3][1]).toEqualJson value: '_', scopes: ['source.asciidoc', 'markup.block.example.asciidoc', 'markup.emphasis.constrained.asciidoc', 'markup.italic.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[3][2]).toEqualJson value: 'delimited', scopes: ['source.asciidoc', 'markup.block.example.asciidoc', 'markup.emphasis.constrained.asciidoc', 'markup.italic.asciidoc']
      expect(tokens[3][3]).toEqualJson value: '_', scopes: ['source.asciidoc', 'markup.block.example.asciidoc', 'markup.emphasis.constrained.asciidoc', 'markup.italic.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[3][4]).toEqualJson value: ' block.', scopes: ['source.asciidoc', 'markup.block.example.asciidoc']
      expect(tokens[4]).toHaveLength 1
      expect(tokens[4][0]).toEqualJson value: '====', scopes: ['source.asciidoc', 'markup.block.example.asciidoc']
