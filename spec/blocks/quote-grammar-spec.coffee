describe 'Should tokenizes quote block when', ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage 'language-asciidoc'

    runs ->
      grammar = atom.grammars.grammarForScopeName 'source.asciidoc'

  # convenience function during development
  debug = (tokens) ->
    console.log(JSON.stringify tokens, null, ' ')

  it 'parses the grammar', ->
    expect(grammar).toBeDefined()
    expect(grammar.scopeName).toBe 'source.asciidoc'

  it 'contains simple phrase', ->
    tokens = grammar.tokenizeLines '''
      [quote, Erwin Schrödinger, Sorry]
      ____
      I don't like it, and I'm sorry I ever had anything to do with it.
      ____
      '''
    expect(tokens).toHaveLength 4
    expect(tokens[0]).toHaveLength 7
    expect(tokens[0][0]).toEqualJson value: '[', scopes: ['source.asciidoc', 'markup.italic.quotes.attributes.asciidoc']
    expect(tokens[0][1]).toEqualJson value: 'quote', scopes: ['source.asciidoc', 'markup.italic.quotes.attributes.asciidoc', 'none.quotes.label.asciidoc' ]
    expect(tokens[0][2]).toEqualJson value: ', ', scopes: ['source.asciidoc', 'markup.italic.quotes.attributes.asciidoc']
    expect(tokens[0][3]).toEqualJson value: 'Erwin Schrödinger', scopes: ['source.asciidoc', 'markup.italic.quotes.attributes.asciidoc', 'none.quotes.attribution.asciidoc']
    expect(tokens[0][4]).toEqualJson value: ', ', scopes: ['source.asciidoc', 'markup.italic.quotes.attributes.asciidoc']
    expect(tokens[0][5]).toEqualJson value: 'Sorry', scopes: ['source.asciidoc', 'markup.italic.quotes.attributes.asciidoc', 'none.quotes.citetitle.asciidoc']
    expect(tokens[0][6]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.italic.quotes.attributes.asciidoc']
    expect(tokens[1]).toHaveLength 1
    expect(tokens[1][0]).toEqualJson value: '____', scopes: ['source.asciidoc', 'markup.italic.quotes.asciidoc']
    expect(tokens[2]).toHaveLength 1
    expect(tokens[2][0]).toEqualJson value: 'I don\'t like it, and I\'m sorry I ever had anything to do with it.', scopes: ['source.asciidoc', 'markup.italic.quotes.asciidoc']
    expect(tokens[3]).toHaveLength 1
    expect(tokens[3][0]).toEqualJson value: '____', scopes: ['source.asciidoc', 'markup.italic.quotes.asciidoc']

  it 'quote declarations with attribution', ->
    {tokens} = grammar.tokenizeLine '[verse, Homer Simpson]\n'
    expect(tokens).toHaveLength 6
    expect(tokens[0]).toEqualJson value: '[', scopes: ['source.asciidoc', 'markup.italic.quotes.attributes.asciidoc']
    expect(tokens[1]).toEqualJson value: 'verse', scopes: ['source.asciidoc', 'markup.italic.quotes.attributes.asciidoc', 'none.quotes.label.asciidoc']
    expect(tokens[2]).toEqualJson value: ', ', scopes: ['source.asciidoc', 'markup.italic.quotes.attributes.asciidoc']
    expect(tokens[3]).toEqualJson value: 'Homer Simpson', scopes: ['source.asciidoc', 'markup.italic.quotes.attributes.asciidoc', 'none.quotes.attribution.asciidoc']
    expect(tokens[4]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.italic.quotes.attributes.asciidoc']
    expect(tokens[5]).toEqualJson value: '\n', scopes: ['source.asciidoc']

  it 'quote declarations with attribution and citation', ->
    {tokens} = grammar.tokenizeLine '[quote, Erwin Schrödinger, Sorry]\n'
    expect(tokens).toHaveLength 8
    expect(tokens[0]).toEqualJson value: '[', scopes: ['source.asciidoc', 'markup.italic.quotes.attributes.asciidoc']
    expect(tokens[1]).toEqualJson value: 'quote', scopes: ['source.asciidoc', 'markup.italic.quotes.attributes.asciidoc', 'none.quotes.label.asciidoc']
    expect(tokens[2]).toEqualJson value: ', ', scopes: ['source.asciidoc', 'markup.italic.quotes.attributes.asciidoc']
    expect(tokens[3]).toEqualJson value: 'Erwin Schrödinger', scopes: ['source.asciidoc', 'markup.italic.quotes.attributes.asciidoc', 'none.quotes.attribution.asciidoc']
    expect(tokens[4]).toEqualJson value: ', ', scopes: ['source.asciidoc', 'markup.italic.quotes.attributes.asciidoc']
    expect(tokens[5]).toEqualJson value: 'Sorry', scopes: ['source.asciidoc', 'markup.italic.quotes.attributes.asciidoc', 'none.quotes.citetitle.asciidoc']
    expect(tokens[6]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.italic.quotes.attributes.asciidoc']
    expect(tokens[7]).toEqualJson value: '\n', scopes: ['source.asciidoc']

  it 'with Markdown style and mix content', ->
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

  it 'with Markdown style and multi-lines', ->
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
