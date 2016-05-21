describe 'Source paragraph', ->
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

    it 'is followed by others grammar parts', ->
      tokens = grammar.tokenizeLines '''
                                      [source,shell]
                                      cd ..

                                      foobar
                                      '''
      expect(tokens).toHaveLength 4 # Number of lines
      expect(tokens[0]).toHaveLength 5
      expect(tokens[0][0]).toEqualJson value: '[', scopes: ['source.asciidoc', 'markup.code.shell.asciidoc', 'markup.heading.asciidoc']
      expect(tokens[0][1]).toEqualJson value: 'source', scopes: ['source.asciidoc', 'markup.code.shell.asciidoc', 'markup.heading.asciidoc', 'markup.meta.attribute-list.asciidoc', 'entity.name.function.asciidoc']
      expect(tokens[0][2]).toEqualJson value: ',', scopes: ['source.asciidoc', 'markup.code.shell.asciidoc', 'markup.heading.asciidoc', 'punctuation.separator.asciidoc']
      expect(tokens[0][3]).toEqualJson value: 'shell', scopes: ['source.asciidoc', 'markup.code.shell.asciidoc', 'markup.heading.asciidoc', 'markup.meta.attribute-list.asciidoc']
      expect(tokens[0][4]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.code.shell.asciidoc', 'markup.heading.asciidoc']
      expect(tokens[1]).toHaveLength 1
      expect(tokens[1][0]).toEqualJson value: 'cd ..', scopes: ['source.asciidoc', 'markup.code.shell.asciidoc']
      expect(tokens[2]).toHaveLength 1
      expect(tokens[2][0]).toEqualJson value: '', scopes: ['source.asciidoc']
      expect(tokens[3]).toHaveLength 1
      expect(tokens[3][0]).toEqualJson value: 'foobar', scopes: ['source.asciidoc']

  describe 'Should not tokenizes when', ->

    it 'beginning with space', ->
      tokens = grammar.tokenizeLines '''
                                       [source,shell]
                                      cd ..

                                      foobar
                                      '''
      expect(tokens).toHaveLength 4 # Number of lines
      expect(tokens[0]).toHaveLength 1
      expect(tokens[0][0]).toEqualJson value: ' [source,shell]', scopes: ['source.asciidoc']
      expect(tokens[1]).toHaveLength 1
      expect(tokens[1][0]).toEqualJson value: 'cd ..', scopes: ['source.asciidoc']
      expect(tokens[2]).toHaveLength 1
      expect(tokens[2][0]).toEqualJson value: '', scopes: ['source.asciidoc']
      expect(tokens[3]).toHaveLength 1
      expect(tokens[3][0]).toEqualJson value: 'foobar', scopes: ['source.asciidoc']
