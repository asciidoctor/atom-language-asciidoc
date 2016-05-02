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
    expect(tokens[0][0]).toEqual value: '[', scopes: ['source.asciidoc']
    expect(tokens[0][1]).toEqual value: 'quote', scopes: ['source.asciidoc', 'markup.quote.declaration.asciidoc']
    expect(tokens[0][2]).toEqual value: ', ', scopes: ['source.asciidoc']
    expect(tokens[0][3]).toEqual value: 'Erwin Schrödinger', scopes: ['source.asciidoc', 'markup.quote.attribution.asciidoc']
    expect(tokens[0][4]).toEqual value: ', ', scopes: ['source.asciidoc']
    expect(tokens[0][5]).toEqual value: 'Sorry', scopes: ['source.asciidoc', 'markup.quote.citation.asciidoc']
    expect(tokens[0][6]).toEqual value: ']', scopes: ['source.asciidoc']
    expect(tokens[1]).toHaveLength 1
    expect(tokens[1][0]).toEqual value: '____', scopes: ['source.asciidoc', 'markup.quote.block.asciidoc']
    expect(tokens[2]).toHaveLength 1
    expect(tokens[2][0]).toEqual value: 'I don\'t like it, and I\'m sorry I ever had anything to do with it.', scopes: ['source.asciidoc', 'markup.quote.block.asciidoc']
    expect(tokens[3]).toHaveLength 1
    expect(tokens[3][0]).toEqual value: '____', scopes: ['source.asciidoc', 'markup.quote.block.asciidoc']
