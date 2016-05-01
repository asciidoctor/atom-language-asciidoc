describe 'Should tokenizes subscript when', ->
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
    {tokens} = grammar.tokenizeLine '~subscript~ is good'
    expect(tokens).toHaveLength 4
    expect(tokens[0]).toEqual value: '~', scopes: ['source.asciidoc', 'markup.sub.asciidoc', 'constant.sub.asciidoc']
    expect(tokens[1]).toEqual value: 'subscript', scopes: ['source.asciidoc', 'markup.sub.asciidoc']
    expect(tokens[2]).toEqual value: '~', scopes: ['source.asciidoc', 'markup.sub.asciidoc', 'constant.sub.asciidoc']
    expect(tokens[3]).toEqual value: ' is good', scopes: ['source.asciidoc']
