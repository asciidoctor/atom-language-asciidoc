describe 'Should tokenizes block title when', ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage 'language-asciidoc'

    runs ->
      grammar = atom.grammars.grammarForScopeName 'source.asciidoc'

  it 'parses the grammar', ->
    expect(grammar).toBeDefined()
    expect(grammar.scopeName).toBe 'source.asciidoc'

  it 'simple title', ->
    {tokens} = grammar.tokenizeLine '.An title example'
    expect(tokens).toHaveLength 2
    expect(tokens[0]).toEqual value: '.', scopes: ['source.asciidoc']
    expect(tokens[1]).toEqual value: 'An title example', scopes: ['source.asciidoc', 'markup.heading.blocktitle.asciidoc']

  it 'simple title with example block', ->
    tokens = grammar.tokenizeLines '''
      .An e-xample' e_xample
      =========
      Example
      =========
      '''
    expect(tokens).toHaveLength 4
    expect(tokens[0]).toHaveLength 2
    expect(tokens[0][0]).toEqual value: '.', scopes: ['source.asciidoc']
    expect(tokens[0][1]).toEqual value: 'An e-xample\' e_xample', scopes: ['source.asciidoc', 'markup.heading.blocktitle.asciidoc']
    expect(tokens[1]).toHaveLength 1
    expect(tokens[1][0]).toEqual value: '=========', scopes: ['source.asciidoc', 'markup.block.example.asciidoc']
    expect(tokens[2]).toHaveLength 1
    expect(tokens[2][0]).toEqual value: 'Example', scopes: ['source.asciidoc', 'markup.block.example.asciidoc']
    expect(tokens[3]).toHaveLength 1
    expect(tokens[3][0]).toEqual value: '=========', scopes: ['source.asciidoc', 'markup.block.example.asciidoc']
