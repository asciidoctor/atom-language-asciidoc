describe 'Should tokenizes characters when', ->
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
    {tokens} = grammar.tokenizeLine 'Dungeons &amp; Dragons'
    expect(tokens).toHaveLength 5
    expect(tokens[0]).toEqual value: 'Dungeons ', scopes: ['source.asciidoc']
    expect(tokens[1]).toEqual value: '&', scopes: ['source.asciidoc', 'markup.htmlentity.asciidoc', 'support.constant.asciidoc']
    expect(tokens[2]).toEqual value: 'amp', scopes: ['source.asciidoc', 'markup.htmlentity.asciidoc']
    expect(tokens[3]).toEqual value: ';', scopes: ['source.asciidoc', 'markup.htmlentity.asciidoc', 'support.constant.asciidoc']
    expect(tokens[4]).toEqual value: ' Dragons', scopes: ['source.asciidoc']

  it 'contains space (invalid context)', ->
    {tokens} = grammar.tokenizeLine 'Dungeons &a mp; Dragons'
    expect(tokens).toHaveLength 1
    expect(tokens[0]).toEqual value: 'Dungeons &a mp; Dragons', scopes: ['source.asciidoc']
