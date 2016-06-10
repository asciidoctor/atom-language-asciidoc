describe 'Listing inline paragraph', ->
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
        [listing]
        A multi-line listing.
        '''

      expect(tokens).toHaveLength 2
      expect(tokens[0]).toHaveLength 3
      expect(tokens[0][0]).toEqualJson value: '[', scopes: ['source.asciidoc', 'markup.block.listing.asciidoc']
      expect(tokens[0][1]).toEqualJson value: 'listing', scopes: ['source.asciidoc', 'markup.block.listing.asciidoc', 'markup.meta.attribute-list.asciidoc', 'entity.name.function.asciidoc']
      expect(tokens[0][2]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.block.listing.asciidoc']
      expect(tokens[1]).toHaveLength 1
      expect(tokens[1][0]).toEqualJson value: 'A multi-line listing.', scopes: ['source.asciidoc', 'markup.block.listing.asciidoc']

  describe 'Should not tokenizes when', ->

    it 'beginning with space', ->
      tokens = grammar.tokenizeLines '''
         [listing]
        A multi-line listing.
        '''

      expect(tokens).toHaveLength 2
      expect(tokens[0]).toHaveLength 1
      expect(tokens[0][0]).toEqualJson value: ' [listing]', scopes: ['source.asciidoc']
      expect(tokens[1]).toHaveLength 1
      expect(tokens[1][0]).toEqualJson value: 'A multi-line listing.', scopes: ['source.asciidoc']
