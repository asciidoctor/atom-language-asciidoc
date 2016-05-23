describe 'Quotes paragraph', ->
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
        [quote, Erwin Schrödinger, Sorry]
        I don't like it, and I'm sorry I ever had anything to do with it.

        foobar
        '''
      expect(tokens).toHaveLength 4
      expect(tokens[0]).toHaveLength 7
      expect(tokens[0][0]).toEqualJson value: '[', scopes: ['source.asciidoc', 'markup.italic.quotes.asciidoc']
      expect(tokens[0][1]).toEqualJson value: 'quote', scopes: ['source.asciidoc', 'markup.italic.quotes.asciidoc', 'markup.meta.attribute-list.asciidoc', 'entity.name.function.asciidoc' ]
      expect(tokens[0][2]).toEqualJson value: ',', scopes: ['source.asciidoc', 'markup.italic.quotes.asciidoc', 'punctuation.separator.asciidoc']
      expect(tokens[0][3]).toEqualJson value: ' Erwin Schrödinger', scopes: ['source.asciidoc', 'markup.italic.quotes.asciidoc', 'markup.meta.attribute-list.asciidoc']
      expect(tokens[0][4]).toEqualJson value: ',', scopes: ['source.asciidoc', 'markup.italic.quotes.asciidoc', 'punctuation.separator.asciidoc']
      expect(tokens[0][5]).toEqualJson value: ' Sorry', scopes: ['source.asciidoc', 'markup.italic.quotes.asciidoc', 'markup.meta.attribute-list.asciidoc']
      expect(tokens[0][6]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.italic.quotes.asciidoc']
      expect(tokens[1]).toHaveLength 1
      expect(tokens[1][0]).toEqualJson value: 'I don\'t like it, and I\'m sorry I ever had anything to do with it.', scopes: ['source.asciidoc', 'markup.italic.quotes.asciidoc']
      expect(tokens[2]).toHaveLength 1
      expect(tokens[2][0]).toEqualJson value: '', scopes: ['source.asciidoc']
      expect(tokens[3]).toHaveLength 1
      expect(tokens[3][0]).toEqualJson value: 'foobar', scopes: ['source.asciidoc']

  it 'block attribute defined with some special characters', ->
    tokens = grammar.tokenizeLines '''
      [quote%option#id]
      I don't like it, and I'm sorry I ever had anything to do with it.

      foobar
      '''
    expect(tokens).toHaveLength 4
    expect(tokens[0]).toHaveLength 7
    expect(tokens[0][0]).toEqualJson value: '[', scopes: ['source.asciidoc', 'markup.italic.quotes.asciidoc']
    expect(tokens[0][1]).toEqualJson value: 'quote', scopes: ['source.asciidoc', 'markup.italic.quotes.asciidoc', 'markup.meta.attribute-list.asciidoc', 'entity.name.function.asciidoc']
    expect(tokens[0][3]).toEqualJson value: 'option', scopes: ['source.asciidoc', 'markup.italic.quotes.asciidoc', 'markup.meta.attribute-list.asciidoc']
    expect(tokens[0][2]).toEqualJson value: '%', scopes: ['source.asciidoc', 'markup.italic.quotes.asciidoc', 'punctuation.separator.asciidoc']
    expect(tokens[0][4]).toEqualJson value: '#', scopes: ['source.asciidoc', 'markup.italic.quotes.asciidoc', 'punctuation.separator.asciidoc']
    expect(tokens[0][5]).toEqualJson value: 'id', scopes: ['source.asciidoc', 'markup.italic.quotes.asciidoc', 'markup.meta.attribute-list.asciidoc']
    expect(tokens[0][6]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.italic.quotes.asciidoc']
    expect(tokens[1]).toHaveLength 1
    expect(tokens[1][0]).toEqualJson value: 'I don\'t like it, and I\'m sorry I ever had anything to do with it.', scopes: ['source.asciidoc', 'markup.italic.quotes.asciidoc']
    expect(tokens[2]).toHaveLength 1
    expect(tokens[2][0]).toEqualJson value: '', scopes: ['source.asciidoc']
    expect(tokens[3]).toHaveLength 1
    expect(tokens[3][0]).toEqualJson value: 'foobar', scopes: ['source.asciidoc']

  describe 'Should not tokenizes when', ->

    it 'beginning with space', ->
      tokens = grammar.tokenizeLines '''
         [quote, Erwin Schrödinger, Sorry]
        I don't like it, and I'm sorry I ever had anything to do with it.

        foobar
        '''
      expect(tokens).toHaveLength 4
      expect(tokens[0]).toHaveLength 1
      expect(tokens[0][0]).toEqualJson value: ' [quote, Erwin Schrödinger, Sorry]', scopes: ['source.asciidoc']
      expect(tokens[1]).toHaveLength 1
      expect(tokens[1][0]).toEqualJson value: 'I don\'t like it, and I\'m sorry I ever had anything to do with it.', scopes: ['source.asciidoc']
      expect(tokens[2]).toHaveLength 1
      expect(tokens[2][0]).toEqualJson value: '', scopes: ['source.asciidoc']
      expect(tokens[3]).toHaveLength 1
      expect(tokens[3][0]).toEqualJson value: 'foobar', scopes: ['source.asciidoc']
