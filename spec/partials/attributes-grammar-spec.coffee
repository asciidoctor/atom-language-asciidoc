describe 'Should tokenizes attributes when', ->
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

  it 'simple attributes not following with text', ->
    {tokens} = grammar.tokenizeLine ':sectanchors:'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqualJson value: ':', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'punctuation.separator.asciidoc']
    expect(tokens[1]).toEqualJson value: 'sectanchors', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'support.constant.attribute-name.asciidoc']
    expect(tokens[2]).toEqualJson value: ':', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'punctuation.separator.asciidoc']

  it 'following with text', ->
    {tokens} = grammar.tokenizeLine ':icons: font'
    expect(tokens).toHaveLength 4
    expect(tokens[0]).toEqualJson value: ':', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'punctuation.separator.asciidoc']
    expect(tokens[1]).toEqualJson value: 'icons', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'support.constant.attribute-name.asciidoc']
    expect(tokens[2]).toEqualJson value: ':', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'punctuation.separator.asciidoc']
    expect(tokens[3]).toEqualJson value: ' font', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'string.unquoted.attribute-value.asciidoc']

  it 'contains negate', ->
    {tokens} = grammar.tokenizeLine ':!compat-mode:'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqualJson value: ':', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'punctuation.separator.asciidoc']
    expect(tokens[1]).toEqualJson value: '!compat-mode', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'support.constant.attribute-name.asciidoc']
    expect(tokens[2]).toEqualJson value: ':', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'punctuation.separator.asciidoc']
