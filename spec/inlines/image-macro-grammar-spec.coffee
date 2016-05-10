describe 'Should tokenizes image/icon macro when', ->
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

  it 'reference a relative path to an image', ->
    {tokens} = grammar.tokenizeLine 'foo image:filename.png[Alt Text] bar'
    expect(tokens).toHaveLength 7
    expect(tokens[0]).toEqual value: 'foo ', scopes: ['source.asciidoc']
    expect(tokens[1]).toEqual value: 'image:', scopes: ['source.asciidoc', 'markup.macro.inline.image.general.asciidoc']
    expect(tokens[2]).toEqual value: 'filename.png', scopes: ['source.asciidoc', 'markup.macro.inline.image.general.asciidoc', 'support.constant.asciidoc']
    expect(tokens[3]).toEqual value: '[', scopes: ['source.asciidoc', 'markup.macro.inline.image.general.asciidoc', 'support.constant.asciidoc']
    expect(tokens[4]).toEqual value: 'Alt Text', scopes: ['source.asciidoc', 'markup.macro.inline.image.general.asciidoc']
    expect(tokens[5]).toEqual value: ']', scopes: ['source.asciidoc', 'markup.macro.inline.image.general.asciidoc', 'support.constant.asciidoc']
    expect(tokens[6]).toEqual value: ' bar', scopes: ['source.asciidoc']

  it 'reference a url to an image', ->
    {tokens} = grammar.tokenizeLine 'foo image:http://example.com/images/filename.png[Alt Text] bar'
    expect(tokens).toHaveLength 7
    expect(tokens[0]).toEqual value: 'foo ', scopes: ['source.asciidoc']
    expect(tokens[1]).toEqual value: 'image:', scopes: ['source.asciidoc', 'markup.macro.inline.image.general.asciidoc']
    expect(tokens[2]).toEqual value: 'http://example.com/images/filename.png', scopes: ['source.asciidoc', 'markup.macro.inline.image.general.asciidoc', 'support.constant.asciidoc']
    expect(tokens[3]).toEqual value: '[', scopes: ['source.asciidoc', 'markup.macro.inline.image.general.asciidoc', 'support.constant.asciidoc']
    expect(tokens[4]).toEqual value: 'Alt Text', scopes: ['source.asciidoc', 'markup.macro.inline.image.general.asciidoc']
    expect(tokens[5]).toEqual value: ']', scopes: ['source.asciidoc', 'markup.macro.inline.image.general.asciidoc', 'support.constant.asciidoc']
    expect(tokens[6]).toEqual value: ' bar', scopes: ['source.asciidoc']

  it 'reference an icon', ->
    {tokens} = grammar.tokenizeLine 'foo icon:github[large] bar'
    expect(tokens).toHaveLength 7
    expect(tokens[0]).toEqual value: 'foo ', scopes: ['source.asciidoc']
    expect(tokens[1]).toEqual value: 'icon:', scopes: ['source.asciidoc', 'markup.macro.inline.image.general.asciidoc']
    expect(tokens[2]).toEqual value: 'github', scopes: ['source.asciidoc', 'markup.macro.inline.image.general.asciidoc', 'support.constant.asciidoc']
    expect(tokens[3]).toEqual value: '[', scopes: ['source.asciidoc', 'markup.macro.inline.image.general.asciidoc', 'support.constant.asciidoc']
    expect(tokens[4]).toEqual value: 'large', scopes: ['source.asciidoc', 'markup.macro.inline.image.general.asciidoc']
    expect(tokens[5]).toEqual value: ']', scopes: ['source.asciidoc', 'markup.macro.inline.image.general.asciidoc', 'support.constant.asciidoc']
    expect(tokens[6]).toEqual value: ' bar', scopes: ['source.asciidoc']
