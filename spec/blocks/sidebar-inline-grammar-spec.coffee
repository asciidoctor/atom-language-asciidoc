describe 'Sidebar inline paragraph', ->
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
        [sidebar]
        A multi-line *sidebar*.
        '''

      expect(tokens).toHaveLength 2
      expect(tokens[0]).toHaveLength 3
      expect(tokens[0][0]).toEqualJson value: '[', scopes: ['source.asciidoc', 'markup.block.sidebar.asciidoc']
      expect(tokens[0][1]).toEqualJson value: 'sidebar', scopes: ['source.asciidoc', 'markup.block.sidebar.asciidoc', 'markup.meta.attribute-list.asciidoc', 'entity.name.function.asciidoc']
      expect(tokens[0][2]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.block.sidebar.asciidoc']
      expect(tokens[1]).toHaveLength 5
      expect(tokens[1][0]).toEqualJson value: 'A multi-line ', scopes: ['source.asciidoc', 'markup.block.sidebar.asciidoc']
      expect(tokens[1][1]).toEqualJson value: '*', scopes: ['source.asciidoc', 'markup.block.sidebar.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[1][2]).toEqualJson value: 'sidebar', scopes: ['source.asciidoc', 'markup.block.sidebar.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc']
      expect(tokens[1][3]).toEqualJson value: '*', scopes: ['source.asciidoc', 'markup.block.sidebar.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[1][4]).toEqualJson value: '.', scopes: ['source.asciidoc', 'markup.block.sidebar.asciidoc']

  describe 'Should not tokenizes when', ->

    it 'beginning with space', ->
      tokens = grammar.tokenizeLines '''
         [sidebar]
        A multi-line *sidebar*.
        '''

      expect(tokens).toHaveLength 2
      expect(tokens[0]).toHaveLength 1
      expect(tokens[0][0]).toEqualJson value: ' [sidebar]', scopes: ['source.asciidoc']
      expect(tokens[1]).toHaveLength 5
      expect(tokens[1][0]).toEqualJson value: 'A multi-line ', scopes: ['source.asciidoc']
      expect(tokens[1][1]).toEqualJson value: '*', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[1][2]).toEqualJson value: 'sidebar', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc']
      expect(tokens[1][3]).toEqualJson value: '*', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[1][4]).toEqualJson value: '.', scopes: ['source.asciidoc']
