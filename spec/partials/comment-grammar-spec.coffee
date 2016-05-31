describe 'Comments', ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage 'language-asciidoc'

    runs ->
      grammar = atom.grammars.grammarForScopeName 'source.asciidoc'

  it 'parses the grammar', ->
    expect(grammar).toBeDefined()
    expect(grammar.scopeName).toBe 'source.asciidoc'

  describe 'inline comment', ->

    describe 'Should tokenizes when', ->

      it 'double slash following with space', ->
        {tokens} = grammar.tokenizeLine '// a comment'
        expect(tokens).toHaveLength 1
        expect(tokens[0]).toEqualJson value: '// a comment', scopes: ['source.asciidoc', 'comment.inline.asciidoc']

      it 'double slash not following with space', ->
        {tokens} = grammar.tokenizeLine '//a comment'
        expect(tokens).toHaveLength 1
        expect(tokens[0]).toEqualJson value: '//a comment', scopes: ['source.asciidoc', 'comment.inline.asciidoc']

    describe 'Should not tokenizes when', ->

      it 'triple slash', ->
        {tokens} = grammar.tokenizeLine '/// a comment'
        expect(tokens).toHaveLength 1
        expect(tokens[0]).toEqualJson value: '/// a comment', scopes: ['source.asciidoc']

  describe 'comment block', ->

    describe 'Should tokenizes when', ->

      it 'simple block', ->
        tokens = grammar.tokenizeLines '''
          ////
          A multi-line comment.

          Notice it's a delimited block.
          ////
          '''
        expect(tokens).toHaveLength 5
        expect(tokens[0]).toHaveLength 1
        expect(tokens[0][0]).toEqualJson value: '////', scopes: ['source.asciidoc', 'comment.block.asciidoc']
        expect(tokens[1]).toHaveLength 1
        expect(tokens[1][0]).toEqualJson value: 'A multi-line comment.', scopes: ['source.asciidoc', 'comment.block.asciidoc']
        expect(tokens[2]).toHaveLength 1
        expect(tokens[2][0]).toEqualJson value: '', scopes: ['source.asciidoc', 'comment.block.asciidoc']
        expect(tokens[3]).toHaveLength 1
        expect(tokens[3][0]).toEqualJson value: 'Notice it\'s a delimited block.', scopes: ['source.asciidoc', 'comment.block.asciidoc']
