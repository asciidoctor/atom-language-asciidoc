describe 'Front matter block', ->
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
        ---
        title:   "Free Operating Systems: A Comparison and Overview"
        date:    2016-04-19 +1000
        layout:  post
        ---
        '''
      expect(tokens).toHaveLength 5
      expect(tokens[0]).toHaveLength 1
      expect(tokens[0][0]).toEqualJson value: '---', scopes: ['source.asciidoc', 'markup.block.front-matter.asciidoc']
      expect(tokens[1]).toHaveLength 1
      expect(tokens[1][0]).toEqualJson value: 'title:   "Free Operating Systems: A Comparison and Overview"', scopes: ['source.asciidoc', 'markup.block.front-matter.asciidoc']
      expect(tokens[2]).toHaveLength 1
      expect(tokens[2][0]).toEqualJson value: 'date:    2016-04-19 +1000', scopes: ['source.asciidoc', 'markup.block.front-matter.asciidoc']
      expect(tokens[3]).toHaveLength 1
      expect(tokens[3][0]).toEqualJson value: 'layout:  post', scopes: ['source.asciidoc', 'markup.block.front-matter.asciidoc']
      expect(tokens[4]).toHaveLength 1
      expect(tokens[4][0]).toEqualJson value: '---', scopes: ['source.asciidoc', 'markup.block.front-matter.asciidoc']
