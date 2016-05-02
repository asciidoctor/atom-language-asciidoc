describe 'Should tokenizes admonition when', ->
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

  it 'start with NOTE:', ->
    {tokens} = grammar.tokenizeLine 'NOTE: This is a note'
    expect(tokens[0]).toEqual value: 'NOTE:', scopes: ['source.asciidoc', 'markup.admonition.asciidoc', 'support.constant.asciidoc']
    expect(tokens[2]).toEqual value: 'This is a note', scopes: ['source.asciidoc', 'markup.admonition.asciidoc']
