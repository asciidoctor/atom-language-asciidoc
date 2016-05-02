describe 'Should tokenizes general block macro when', ->
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

  it 'reference a gist', ->
    {tokens} = grammar.tokenizeLine 'gist::123456[]'
    expect(tokens).toHaveLength 4
    expect(tokens[0]).toEqual value: 'gist::', scopes: ['source.asciidoc', 'markup.macro.block.general.asciidoc', 'support.constant.asciidoc']
    expect(tokens[1]).toEqual value: '123456', scopes: ['source.asciidoc', 'markup.macro.block.general.asciidoc']
    expect(tokens[2]).toEqual value: '[', scopes: ['source.asciidoc', 'markup.macro.block.general.asciidoc', 'support.constant.asciidoc']
    expect(tokens[3]).toEqual value: ']', scopes: ['source.asciidoc', 'markup.macro.block.general.asciidoc', 'support.constant.asciidoc']

  it 'reference an image', ->
    {tokens} = grammar.tokenizeLine 'image::filename.png[Caption]'
    expect(tokens).toHaveLength 5
    expect(tokens[0]).toEqual value: 'image::', scopes: ['source.asciidoc', 'markup.macro.block.general.asciidoc', 'support.constant.asciidoc']
    expect(tokens[1]).toEqual value: 'filename.png', scopes: ['source.asciidoc', 'markup.macro.block.general.asciidoc']
    expect(tokens[2]).toEqual value: '[', scopes: ['source.asciidoc', 'markup.macro.block.general.asciidoc', 'support.constant.asciidoc']
    expect(tokens[3]).toEqual value: 'Caption', scopes: ['source.asciidoc', 'markup.macro.block.general.asciidoc']
    expect(tokens[4]).toEqual value: ']', scopes: ['source.asciidoc', 'markup.macro.block.general.asciidoc', 'support.constant.asciidoc']

  it 'reference a video', ->
    {tokens} = grammar.tokenizeLine 'video::http://youtube.com/12345[Cats vs Dogs]'
    expect(tokens).toHaveLength 5
    expect(tokens[0]).toEqual value: 'video::', scopes: ['source.asciidoc', 'markup.macro.block.general.asciidoc', 'support.constant.asciidoc']
    expect(tokens[1]).toEqual value: 'http://youtube.com/12345', scopes: ['source.asciidoc', 'markup.macro.block.general.asciidoc']
    expect(tokens[2]).toEqual value: '[', scopes: ['source.asciidoc', 'markup.macro.block.general.asciidoc', 'support.constant.asciidoc']
    expect(tokens[3]).toEqual value: 'Cats vs Dogs', scopes: ['source.asciidoc', 'markup.macro.block.general.asciidoc']
    expect(tokens[4]).toEqual value: ']', scopes: ['source.asciidoc', 'markup.macro.block.general.asciidoc', 'support.constant.asciidoc']

  it 'not at the line beginning (invalid context)', ->
    {tokens} = grammar.tokenizeLine 'foo image::filename.png[Caption]'
    expect(tokens).toHaveLength 1
    expect(tokens[0]).toEqual value: 'foo image::filename.png[Caption]', scopes: ['source.asciidoc']
