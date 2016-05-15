describe 'Quotes with Markdown style', ->
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

    it 'include inlines element', ->
      tokens = grammar.tokenizeLines '''
        > I've got Markdown in my AsciiDoc!
        >
        > *strong*
        > Yep. AsciiDoc and Markdown share a lot of common syntax already.
        '''
      expect(tokens).toHaveLength 4
      expect(tokens[0]).toHaveLength 2
      expect(tokens[0][0]).toEqualJson value: '> ', scopes: ['source.asciidoc', 'markup.italic.quotes.asciidoc']
      expect(tokens[0][1]).toEqualJson value: 'I\'ve got Markdown in my AsciiDoc!', scopes: ['source.asciidoc', 'markup.italic.quotes.asciidoc']
      expect(tokens[1]).toHaveLength 1
      expect(tokens[1][0]).toEqualJson value: '>', scopes: ['source.asciidoc', 'markup.italic.quotes.asciidoc']
      expect(tokens[2]).toHaveLength 4
      expect(tokens[2][0]).toEqualJson value: '> ', scopes: ['source.asciidoc', 'markup.italic.quotes.asciidoc']
      expect(tokens[2][1]).toEqualJson value: '*', scopes: ['source.asciidoc', 'markup.italic.quotes.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[2][2]).toEqualJson value: 'strong', scopes: ['source.asciidoc', 'markup.italic.quotes.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc']
      expect(tokens[2][3]).toEqualJson value: '*', scopes: ['source.asciidoc', 'markup.italic.quotes.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[3]).toHaveLength 1
      expect(tokens[3][0]).toEqualJson value: '> Yep. AsciiDoc and Markdown share a lot of common syntax already.', scopes: ['source.asciidoc', 'markup.italic.quotes.asciidoc']

    it 'contains multi-lines', ->
      tokens = grammar.tokenizeLines '''
        foobar
        > I don't like it, and I'm sorry I ever had anything to do with it.
        > Erwin Schrödinger, Sorry
        foobar foobar
        foobar

        foobar
        '''
      expect(tokens).toHaveLength 7
      expect(tokens[0]).toHaveLength 1
      expect(tokens[0][0]).toEqualJson value: 'foobar', scopes: ['source.asciidoc']
      expect(tokens[1]).toHaveLength 2
      expect(tokens[1][0]).toEqualJson value: '> ', scopes: ['source.asciidoc', 'markup.italic.quotes.asciidoc']
      expect(tokens[1][1]).toEqualJson value: 'I don\'t like it, and I\'m sorry I ever had anything to do with it.', scopes: ['source.asciidoc', 'markup.italic.quotes.asciidoc']
      expect(tokens[2]).toHaveLength 1
      expect(tokens[2][0]).toEqualJson value: '> Erwin Schrödinger, Sorry', scopes: ['source.asciidoc', 'markup.italic.quotes.asciidoc']
      expect(tokens[3]).toHaveLength 1
      expect(tokens[3][0]).toEqualJson value: 'foobar foobar', scopes: ['source.asciidoc', 'markup.italic.quotes.asciidoc']
      expect(tokens[4]).toHaveLength 1
      expect(tokens[4][0]).toEqualJson value: 'foobar', scopes: ['source.asciidoc', 'markup.italic.quotes.asciidoc']
      expect(tokens[5]).toHaveLength 1
      expect(tokens[5][0]).toEqualJson value: '', scopes: ['source.asciidoc']
      expect(tokens[6]).toHaveLength 1
      expect(tokens[6][0]).toEqualJson value: 'foobar', scopes: ['source.asciidoc']
