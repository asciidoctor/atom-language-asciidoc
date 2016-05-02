describe 'Should tokenizes example block when', ->
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

  it 'contains others grammars', ->
    tokens = grammar.tokenizeLines '''
      ====
      A multi-line *example*.

      Notice it's a _delimited_ block.
      ====
      '''
    expect(tokens).toHaveLength 5
    expect(tokens[0]).toHaveLength 1
    expect(tokens[0][0]).toEqual value: '====', scopes: ['source.asciidoc', 'markup.block.example.asciidoc']
    expect(tokens[1]).toHaveLength 5
    expect(tokens[1][0]).toEqual value: 'A multi-line ', scopes: ['source.asciidoc', 'markup.block.example.asciidoc']
    expect(tokens[1][1]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.block.example.asciidoc', 'markup.bold.constrained.asciidoc', 'support.constant.asciidoc']
    expect(tokens[1][2]).toEqual value: 'example', scopes: ['source.asciidoc', 'markup.block.example.asciidoc', 'markup.bold.constrained.asciidoc']
    expect(tokens[1][3]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.block.example.asciidoc', 'markup.bold.constrained.asciidoc', 'support.constant.asciidoc']
    expect(tokens[1][4]).toEqual value: '.', scopes: ['source.asciidoc', 'markup.block.example.asciidoc']
    expect(tokens[2]).toHaveLength 1
    expect(tokens[2][0]).toEqual value: '', scopes: ['source.asciidoc', 'markup.block.example.asciidoc']
    expect(tokens[3]).toHaveLength 3
    expect(tokens[3][0]).toEqual value: 'Notice it\'s a ', scopes: ['source.asciidoc', 'markup.block.example.asciidoc']
    expect(tokens[3][1]).toEqual value: '_delimited_', scopes: ['source.asciidoc', 'markup.block.example.asciidoc', 'markup.italic.asciidoc']
    expect(tokens[3][2]).toEqual value: ' block.', scopes: ['source.asciidoc', 'markup.block.example.asciidoc']
    expect(tokens[4]).toHaveLength 1
    expect(tokens[4][0]).toEqual value: '====', scopes: ['source.asciidoc', 'markup.block.example.asciidoc']
