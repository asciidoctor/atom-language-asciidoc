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
    expect(tokens[0]).toEqualJson value: 'Dungeons ', scopes: ['source.asciidoc']
    expect(tokens[1]).toEqualJson value: '&', scopes: ['source.asciidoc', 'markup.character-reference.asciidoc', 'constant.character.asciidoc']
    expect(tokens[2]).toEqualJson value: 'amp', scopes: ['source.asciidoc', 'markup.character-reference.asciidoc']
    expect(tokens[3]).toEqualJson value: ';', scopes: ['source.asciidoc', 'markup.character-reference.asciidoc', 'constant.character.asciidoc']
    expect(tokens[4]).toEqualJson value: ' Dragons', scopes: ['source.asciidoc']

  it 'contains space (invalid context)', ->
    {tokens} = grammar.tokenizeLine 'Dungeons &a mp; Dragons'
    expect(tokens).toHaveLength 1
    expect(tokens[0]).toEqualJson value: 'Dungeons &a mp; Dragons', scopes: ['source.asciidoc']
