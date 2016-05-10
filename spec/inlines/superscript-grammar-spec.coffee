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
    expect(tokens[0]).toEqual value: '^', scopes: ['source.asciidoc', 'markup.super.asciidoc', 'punctuation.definition.entity.asciidoc']
    expect(tokens[1]).toEqual value: 'superscript', scopes: ['source.asciidoc', 'markup.super.asciidoc']
    expect(tokens[2]).toEqual value: '^', scopes: ['source.asciidoc', 'markup.super.asciidoc', 'punctuation.definition.entity.asciidoc']
    expect(tokens[3]).toEqual value: ' is good', scopes: ['source.asciidoc']

  it 'when having a [role] set on ^superscript^ text', ->
    {tokens} = grammar.tokenizeLine '[role]^superscript^'
    expect(tokens).toHaveLength 4
    expect(tokens[0]).toEqual value: '[role]', scopes: ['source.asciidoc', 'markup.super.asciidoc', 'markup.meta.attrlist.asciidoc']
    expect(tokens[1]).toEqual value: '^', scopes: ['source.asciidoc', 'markup.super.asciidoc', 'punctuation.definition.entity.asciidoc']
    expect(tokens[2]).toEqual value: 'superscript', scopes: ['source.asciidoc', 'markup.super.asciidoc']
    expect(tokens[3]).toEqual value: '^', scopes: ['source.asciidoc', 'markup.super.asciidoc', 'punctuation.definition.entity.asciidoc']

  it 'when having [role1 role2] set on ^superscript^ text', ->
    {tokens} = grammar.tokenizeLine '[role1 role2]^superscript^'
    expect(tokens).toHaveLength 4
    expect(tokens[0]).toEqual value: '[role1 role2]', scopes: ['source.asciidoc', 'markup.super.asciidoc', 'markup.meta.attrlist.asciidoc']
    expect(tokens[1]).toEqual value: '^', scopes: ['source.asciidoc', 'markup.super.asciidoc', 'punctuation.definition.entity.asciidoc']
    expect(tokens[2]).toEqual value: 'superscript', scopes: ['source.asciidoc', 'markup.super.asciidoc']
    expect(tokens[3]).toEqual value: '^', scopes: ['source.asciidoc', 'markup.super.asciidoc', 'punctuation.definition.entity.asciidoc']
