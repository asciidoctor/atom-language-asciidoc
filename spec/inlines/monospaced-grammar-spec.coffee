describe '`monospaced`', ->
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

  describe 'Should tokenizes constrained `monospaced` when', ->

    it 'is in a phrase', ->
      {tokens} = grammar.tokenizeLine '`Text in backticks` renders exactly as entered, in `monospaced`.'
      expect(tokens).toHaveLength 4
      expect(tokens[0]).toEqual value: '`Text in backticks`', scopes: ['source.asciidoc', 'markup.raw.constrained.monospaced.asciidoc']
      expect(tokens[1]).toEqual value: ' renders exactly as entered, in', scopes: ['source.asciidoc']
      expect(tokens[2]).toEqual value: ' `monospaced`', scopes: ['source.asciidoc', 'markup.raw.constrained.monospaced.asciidoc']
      expect(tokens[3]).toEqual value: '.', scopes: ['source.asciidoc']

    it 'is not in valid context', ->
      {tokens} = grammar.tokenizeLine 'Text in back`ticks` renders exactly as entered, in mono`spaced`.'
      expect(tokens).toHaveLength 1
      expect(tokens[0]).toEqual value: 'Text in back`ticks` renders exactly as entered, in mono`spaced`.', scopes: ['source.asciidoc']

  describe 'Should tokenizes unconstrained `monospaced` when', ->

    it 'is in a phrase', ->
      {tokens} = grammar.tokenizeLine 'Text in back``ticks`` renders exactly as entered, in mono``spaced``.'
      expect(tokens).toHaveLength 5
      expect(tokens[0]).toEqual value: 'Text in back', scopes: ['source.asciidoc']
      expect(tokens[1]).toEqual value: '``ticks``', scopes: ['source.asciidoc', 'markup.raw.unconstrained.monospaced.asciidoc']
      expect(tokens[2]).toEqual value: ' renders exactly as entered, in mono', scopes: ['source.asciidoc']
      expect(tokens[3]).toEqual value: '``spaced``', scopes: ['source.asciidoc', 'markup.raw.unconstrained.monospaced.asciidoc']
      expect(tokens[4]).toEqual value: '.', scopes: ['source.asciidoc']
