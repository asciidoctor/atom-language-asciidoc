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
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqual value: 'NOTE:', scopes: ['source.asciidoc', 'markup.admonition.asciidoc', 'support.constant.label.asciidoc']
    expect(tokens[1]).toEqual value: ' ', scopes: ['source.asciidoc', 'markup.admonition.asciidoc']
    expect(tokens[2]).toEqual value: 'This is a note', scopes: ['source.asciidoc', 'markup.admonition.asciidoc']

  it 'start with NOTE: and have several lines', ->
    tokens = grammar.tokenizeLines '''
      foobar

      NOTE: An admonition paragraph draws the reader's attention to
      auxiliary information.
      Its purpose is *determined* by the label
      at the _beginning_ of the paragraph.

      foobar
      '''
    expect(tokens).toHaveLength 8 # Number of lines
    expect(tokens[0]).toHaveLength 1
    expect(tokens[0][0]).toEqual value: 'foobar', scopes: ['source.asciidoc']
    expect(tokens[1]).toHaveLength 1
    expect(tokens[1][0]).toEqual value: '', scopes: ['source.asciidoc']
    expect(tokens[2]).toHaveLength 3
    expect(tokens[2][0]).toEqual value: 'NOTE:', scopes: ['source.asciidoc', 'markup.admonition.asciidoc', 'support.constant.label.asciidoc']
    expect(tokens[2][1]).toEqual value: ' ', scopes: ['source.asciidoc', 'markup.admonition.asciidoc']
    expect(tokens[2][2]).toEqual value: 'An admonition paragraph draws the reader\'s attention to', scopes: ['source.asciidoc', 'markup.admonition.asciidoc']
    expect(tokens[3]).toHaveLength 1
    expect(tokens[3][0]).toEqual value: 'auxiliary information.', scopes: ['source.asciidoc', 'markup.admonition.asciidoc']
    expect(tokens[4]).toHaveLength 5
    expect(tokens[4][0]).toEqual value: 'Its purpose is ', scopes: ['source.asciidoc', 'markup.admonition.asciidoc']
    expect(tokens[4][1]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.admonition.asciidoc', 'markup.strong.constrained.asciidoc', 'punctuation.definition.bold.asciidoc']
    expect(tokens[4][2]).toEqual value: 'determined', scopes: ['source.asciidoc', 'markup.admonition.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.strong.asciidoc']
    expect(tokens[4][3]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.admonition.asciidoc', 'markup.strong.constrained.asciidoc', 'punctuation.definition.bold.asciidoc']
    expect(tokens[4][4]).toEqual value: ' by the label', scopes: ['source.asciidoc', 'markup.admonition.asciidoc']
    expect(tokens[5]).toHaveLength 5
    expect(tokens[5][0]).toEqual value: 'at the ', scopes: ['source.asciidoc', 'markup.admonition.asciidoc']
    expect(tokens[5][1]).toEqual value: '_', scopes: ['source.asciidoc', 'markup.admonition.asciidoc', 'markup.emphasis.constrained.asciidoc', 'punctuation.definition.italic.asciidoc']
    expect(tokens[5][2]).toEqual value: 'beginning', scopes: ['source.asciidoc', 'markup.admonition.asciidoc', 'markup.emphasis.constrained.asciidoc', 'markup.italic.emphasis.asciidoc']
    expect(tokens[5][3]).toEqual value: '_', scopes: ['source.asciidoc', 'markup.admonition.asciidoc', 'markup.emphasis.constrained.asciidoc', 'punctuation.definition.italic.asciidoc']
    expect(tokens[5][4]).toEqual value: ' of the paragraph.', scopes: ['source.asciidoc', 'markup.admonition.asciidoc']
    expect(tokens[6]).toHaveLength 1
    expect(tokens[6][0]).toEqual value: '', scopes: ['source.asciidoc']
    expect(tokens[7]).toHaveLength 1
    expect(tokens[7][0]).toEqual value: 'foobar', scopes: ['source.asciidoc']

  it 'start with TIP:', ->
    {tokens} = grammar.tokenizeLine 'TIP: Pro tip...'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqual value: 'TIP:', scopes: ['source.asciidoc', 'markup.admonition.asciidoc', 'support.constant.label.asciidoc']
    expect(tokens[1]).toEqual value: ' ', scopes: ['source.asciidoc', 'markup.admonition.asciidoc']
    expect(tokens[2]).toEqual value: 'Pro tip...', scopes: ['source.asciidoc', 'markup.admonition.asciidoc']

  it 'start with IMPORTANT:', ->
    {tokens} = grammar.tokenizeLine 'IMPORTANT: Don\'t forget...'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqual value: 'IMPORTANT:', scopes: ['source.asciidoc', 'markup.admonition.asciidoc', 'support.constant.label.asciidoc']
    expect(tokens[1]).toEqual value: ' ', scopes: ['source.asciidoc', 'markup.admonition.asciidoc']
    expect(tokens[2]).toEqual value: 'Don\'t forget...', scopes: ['source.asciidoc', 'markup.admonition.asciidoc']

  it 'start with WARNING:', ->
    {tokens} = grammar.tokenizeLine 'WARNING: Watch out for...'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqual value: 'WARNING:', scopes: ['source.asciidoc', 'markup.admonition.asciidoc', 'support.constant.label.asciidoc']
    expect(tokens[1]).toEqual value: ' ', scopes: ['source.asciidoc', 'markup.admonition.asciidoc']
    expect(tokens[2]).toEqual value: 'Watch out for...', scopes: ['source.asciidoc', 'markup.admonition.asciidoc']

  it 'start with CAUTION:', ->
    {tokens} = grammar.tokenizeLine 'CAUTION: Ensure that...'
    expect(tokens).toHaveLength 3
    expect(tokens[0]).toEqual value: 'CAUTION:', scopes: ['source.asciidoc', 'markup.admonition.asciidoc', 'support.constant.label.asciidoc']
    expect(tokens[1]).toEqual value: ' ', scopes: ['source.asciidoc', 'markup.admonition.asciidoc']
    expect(tokens[2]).toEqual value: 'Ensure that...', scopes: ['source.asciidoc', 'markup.admonition.asciidoc']
