describe 'Should tokenizes superscript when', ->
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

  it 'simple phrase', ->
    {tokens} = grammar.tokenizeLine '^superscript^ is good'
    expect(tokens).toHaveLength 4
    expect(tokens[0]).toEqual value: '^', scopes: ['source.asciidoc', 'markup.super.asciidoc', 'constant.super.asciidoc']
    expect(tokens[1]).toEqual value: 'superscript', scopes: ['source.asciidoc', 'markup.super.asciidoc']
    expect(tokens[2]).toEqual value: '^', scopes: ['source.asciidoc', 'markup.super.asciidoc', 'constant.super.asciidoc']
    expect(tokens[3]).toEqual value: ' is good', scopes: ['source.asciidoc']
