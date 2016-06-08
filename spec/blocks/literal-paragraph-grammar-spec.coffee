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
        Type the following command:

         $ gem install asciidoctor

        Asciidoctor should now be installed on your machine.
        '''
      expect(tokens).toHaveLength 5
      expect(tokens[0]).toHaveLength 1
      expect(tokens[0][0]).toEqualJson value: 'Type the following command:', scopes: ['source.asciidoc']
      expect(tokens[1]).toHaveLength 1
      expect(tokens[1][0]).toEqualJson value: '', scopes: ['source.asciidoc']
      expect(tokens[2]).toHaveLength 1
      expect(tokens[2][0]).toEqualJson value: ' $ gem install asciidoctor', scopes: ['source.asciidoc', 'markup.block.literal.asciidoc']
      expect(tokens[3]).toHaveLength 1
      expect(tokens[3][0]).toEqualJson value: '', scopes: ['source.asciidoc']
      expect(tokens[4]).toHaveLength 1
      expect(tokens[4][0]).toEqualJson value: 'Asciidoctor should now be installed on your machine.', scopes: ['source.asciidoc']
