describe 'Should tokenizes bibliography-anchor when', ->
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

  it 'is in a phrase', ->
    {tokens} = grammar.tokenizeLine 'foobar [[[bib-ref]]] foobar'
    expect(tokens).toHaveLength 5
    expect(tokens[0]).toEqual value: 'foobar ', scopes: ['source.asciidoc']
    expect(tokens[1]).toEqual value: '[[[', scopes: ['source.asciidoc', 'bibliography-anchor.asciidoc', 'support.constant.asciidoc']
    expect(tokens[2]).toEqual value: 'bib-ref', scopes: ['source.asciidoc', 'bibliography-anchor.asciidoc', 'markup.biblioref.asciidoc']
    expect(tokens[3]).toEqual value: ']]]', scopes: ['source.asciidoc', 'bibliography-anchor.asciidoc', 'support.constant.asciidoc']
    expect(tokens[4]).toEqual value: ' foobar', scopes: ['source.asciidoc']
