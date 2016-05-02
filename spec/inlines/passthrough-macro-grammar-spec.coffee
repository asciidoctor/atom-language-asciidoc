describe 'Should tokenizes passthrough macro when', ->
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

  it 'as attribute, started at the beginning of the line and without text after.', ->
    {tokens} = grammar.tokenizeLine 'pass:q,c[<u>underline *me*</u>]'
    expect(tokens).toHaveLength 4
    expect(tokens[0]).toEqual value: 'pass:', scopes: ['source.asciidoc', 'markup.macro.inline.passthrough.asciidoc', 'support.constant.passthrough.inline.asciidoc']
    expect(tokens[1]).toEqual value: 'q,c[', scopes: ['source.asciidoc', 'markup.macro.inline.passthrough.asciidoc']
    expect(tokens[2]).toEqual value: '<u>underline *me*</u>', scopes: ['source.asciidoc', 'markup.macro.inline.passthrough.asciidoc']
    expect(tokens[3]).toEqual value: ']', scopes: ['source.asciidoc', 'markup.macro.inline.passthrough.asciidoc']

  it 'as attribute, in a phrase.', ->
    {tokens} = grammar.tokenizeLine 'A pass:o,x[<u>underline *me*</u>] followed by normal content.'
    expect(tokens).toHaveLength 6
    expect(tokens[0]).toEqual value: 'A ', scopes: ['source.asciidoc']
    expect(tokens[1]).toEqual value: 'pass:', scopes: ['source.asciidoc', 'markup.macro.inline.passthrough.asciidoc', 'support.constant.passthrough.inline.asciidoc']
    expect(tokens[2]).toEqual value: 'o,x[', scopes: ['source.asciidoc', 'markup.macro.inline.passthrough.asciidoc']
    expect(tokens[3]).toEqual value: '<u>underline *me*</u>', scopes: ['source.asciidoc', 'markup.macro.inline.passthrough.asciidoc']
    expect(tokens[4]).toEqual value: ']', scopes: ['source.asciidoc', 'markup.macro.inline.passthrough.asciidoc']
    expect(tokens[5]).toEqual value: ' followed by normal content.', scopes: ['source.asciidoc']

  it 'as triple-plus, in a phrase.', ->
    {tokens} = grammar.tokenizeLine 'A +++<u>underline *me*</u>+++ followed by normal content.'
    expect(tokens).toHaveLength 5
    expect(tokens[0]).toEqual value: 'A ', scopes: ['source.asciidoc']
    expect(tokens[1]).toEqual value: '+++', scopes: ['source.asciidoc', 'markup.macro.inline.passthrough.asciidoc', 'support.constant.passthrough.inline.asciidoc']
    expect(tokens[2]).toEqual value: '<u>underline *me*</u>', scopes: ['source.asciidoc', 'markup.macro.inline.passthrough.asciidoc']
    expect(tokens[3]).toEqual value: '+++', scopes: ['source.asciidoc', 'markup.macro.inline.passthrough.asciidoc', 'support.constant.passthrough.inline.asciidoc']
    expect(tokens[4]).toEqual value: ' followed by normal content.', scopes: ['source.asciidoc']

  it 'as double-dollar, in a phrase.', ->
    {tokens} = grammar.tokenizeLine 'A $$<u>underline *me*</u>$$ followed by normal content.'
    expect(tokens).toHaveLength 5
    expect(tokens[0]).toEqual value: 'A ', scopes: ['source.asciidoc']
    expect(tokens[1]).toEqual value: '$$', scopes: ['source.asciidoc', 'markup.macro.inline.passthrough.asciidoc', 'support.constant.passthrough.inline.asciidoc']
    expect(tokens[2]).toEqual value: '<u>underline *me*</u>', scopes: ['source.asciidoc', 'markup.macro.inline.passthrough.asciidoc']
    expect(tokens[3]).toEqual value: '$$', scopes: ['source.asciidoc', 'markup.macro.inline.passthrough.asciidoc', 'support.constant.passthrough.inline.asciidoc']
    expect(tokens[4]).toEqual value: ' followed by normal content.', scopes: ['source.asciidoc']
