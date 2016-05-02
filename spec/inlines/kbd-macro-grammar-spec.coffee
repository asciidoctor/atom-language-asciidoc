describe 'Should tokenizes keyboard macro when', ->
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

  it 'simple key', ->
    {tokens} = grammar.tokenizeLine 'foo kbd:[F3] bar'
    expect(tokens).toHaveLength 5
    expect(tokens[0]).toEqual value: 'foo ', scopes: ['source.asciidoc']
    expect(tokens[1]).toEqual value: 'kbd:[', scopes: ['source.asciidoc', 'markup.macro.inline.kbd.general.asciidoc']
    expect(tokens[2]).toEqual value: 'F3', scopes: ['source.asciidoc', 'markup.macro.inline.kbd.general.asciidoc', 'support.constant.asciidoc']
    expect(tokens[3]).toEqual value: ']', scopes: ['source.asciidoc', 'markup.macro.inline.kbd.general.asciidoc']
    expect(tokens[4]).toEqual value: ' bar', scopes: ['source.asciidoc']

  it 'several keys', ->
    {tokens} = grammar.tokenizeLine 'foo kbd:[Ctrl+Shift+T] bar'
    expect(tokens).toHaveLength 5
    expect(tokens[0]).toEqual value: 'foo ', scopes: ['source.asciidoc']
    expect(tokens[1]).toEqual value: 'kbd:[', scopes: ['source.asciidoc', 'markup.macro.inline.kbd.general.asciidoc']
    expect(tokens[2]).toEqual value: 'Ctrl+Shift+T', scopes: ['source.asciidoc', 'markup.macro.inline.kbd.general.asciidoc', 'support.constant.asciidoc']
    expect(tokens[3]).toEqual value: ']', scopes: ['source.asciidoc', 'markup.macro.inline.kbd.general.asciidoc']
    expect(tokens[4]).toEqual value: ' bar', scopes: ['source.asciidoc']

  it 'contains ]', ->
    {tokens} = grammar.tokenizeLine 'foo kbd:[Ctrl+\]] bar'
    expect(tokens).toHaveLength 5
    expect(tokens[0]).toEqual value: 'foo ', scopes: ['source.asciidoc']
    expect(tokens[1]).toEqual value: 'kbd:[', scopes: ['source.asciidoc', 'markup.macro.inline.kbd.general.asciidoc']
    expect(tokens[2]).toEqual value: 'Ctrl+', scopes: ['source.asciidoc', 'markup.macro.inline.kbd.general.asciidoc', 'support.constant.asciidoc']
    expect(tokens[3]).toEqual value: ']', scopes: ['source.asciidoc', 'markup.macro.inline.kbd.general.asciidoc']
    expect(tokens[4]).toEqual value: '] bar', scopes: ['source.asciidoc']

  it 'contains a label', ->
    {tokens} = grammar.tokenizeLine 'foo btn:[Save] bar'
    expect(tokens).toHaveLength 5
    expect(tokens[0]).toEqual value: 'foo ', scopes: ['source.asciidoc']
    expect(tokens[1]).toEqual value: 'btn:[', scopes: ['source.asciidoc', 'markup.macro.inline.kbd.general.asciidoc']
    expect(tokens[2]).toEqual value: 'Save', scopes: ['source.asciidoc', 'markup.macro.inline.kbd.general.asciidoc', 'support.constant.asciidoc']
    expect(tokens[3]).toEqual value: ']', scopes: ['source.asciidoc', 'markup.macro.inline.kbd.general.asciidoc']
    expect(tokens[4]).toEqual value: ' bar', scopes: ['source.asciidoc']
