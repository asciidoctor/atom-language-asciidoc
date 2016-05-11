describe '`monospace`', ->
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

  describe 'Should tokenizes constrained `monospace` when', ->

    it 'is in a phrase', ->
      {tokens} = grammar.tokenizeLine '`Text in backticks` renders exactly as entered, in `monospace`.'
      expect(tokens).toHaveLength 8
      expect(tokens[0]).toEqual value: '`', scopes: ['source.asciidoc', 'markup.monospace.constrained.asciidoc', 'punctuation.definition.raw.asciidoc']
      expect(tokens[1]).toEqual value: 'Text in backticks', scopes: ['source.asciidoc', 'markup.monospace.constrained.asciidoc', 'markup.raw.monospace.asciidoc']
      expect(tokens[2]).toEqual value: '`', scopes: ['source.asciidoc', 'markup.monospace.constrained.asciidoc', 'punctuation.definition.raw.asciidoc']
      expect(tokens[3]).toEqual value: ' renders exactly as entered, in ', scopes: ['source.asciidoc']
      expect(tokens[4]).toEqual value: '`', scopes: ['source.asciidoc', 'markup.monospace.constrained.asciidoc', 'punctuation.definition.raw.asciidoc']
      expect(tokens[5]).toEqual value: 'monospace', scopes: ['source.asciidoc', 'markup.monospace.constrained.asciidoc', 'markup.raw.monospace.asciidoc']
      expect(tokens[6]).toEqual value: '`', scopes: ['source.asciidoc', 'markup.monospace.constrained.asciidoc', 'punctuation.definition.raw.asciidoc']
      expect(tokens[7]).toEqual value: '.', scopes: ['source.asciidoc']

    it 'is not in valid context', ->
      {tokens} = grammar.tokenizeLine 'Text in back`ticks` renders exactly as entered, in mono`spaced`.'
      expect(tokens).toHaveLength 1
      expect(tokens[0]).toEqual value: 'Text in back`ticks` renders exactly as entered, in mono`spaced`.', scopes: ['source.asciidoc']

    it 'when having a [role] set on constrained `monospace` text', ->
      {tokens} = grammar.tokenizeLine '[role]`monospace`'
      expect(tokens).toHaveLength 4
      expect(tokens[0]).toEqual value: '[role]', scopes: ['source.asciidoc', 'markup.monospace.constrained.asciidoc', 'markup.meta.attrlist.asciidoc']
      expect(tokens[1]).toEqual value: '`', scopes: ['source.asciidoc', 'markup.monospace.constrained.asciidoc', 'punctuation.definition.raw.asciidoc']
      expect(tokens[2]).toEqual value: 'monospace', scopes: ['source.asciidoc', 'markup.monospace.constrained.asciidoc', 'markup.raw.monospace.asciidoc']
      expect(tokens[3]).toEqual value: '`', scopes: ['source.asciidoc', 'markup.monospace.constrained.asciidoc', 'punctuation.definition.raw.asciidoc']

    it 'when having [role1 role2] set on constrained `monospace` text', ->
      {tokens} = grammar.tokenizeLine '[role1 role2]`monospace`'
      expect(tokens).toHaveLength 4
      expect(tokens[0]).toEqual value: '[role1 role2]', scopes: ['source.asciidoc', 'markup.monospace.constrained.asciidoc', 'markup.meta.attrlist.asciidoc']
      expect(tokens[1]).toEqual value: '`', scopes: ['source.asciidoc', 'markup.monospace.constrained.asciidoc', 'punctuation.definition.raw.asciidoc']
      expect(tokens[2]).toEqual value: 'monospace', scopes: ['source.asciidoc', 'markup.monospace.constrained.asciidoc', 'markup.raw.monospace.asciidoc']
      expect(tokens[3]).toEqual value: '`', scopes: ['source.asciidoc', 'markup.monospace.constrained.asciidoc', 'punctuation.definition.raw.asciidoc']

  describe 'Should tokenizes unconstrained `monospace` when', ->

    it 'is in a phrase', ->
      {tokens} = grammar.tokenizeLine 'Text in back``ticks`` renders exactly as entered, in mono``space``.'
      expect(tokens).toHaveLength 9
      expect(tokens[0]).toEqual value: 'Text in back', scopes: ['source.asciidoc']
      expect(tokens[1]).toEqual value: '``', scopes: ['source.asciidoc', 'markup.monospace.unconstrained.asciidoc', 'punctuation.definition.raw.asciidoc']
      expect(tokens[2]).toEqual value: 'ticks', scopes: ['source.asciidoc', 'markup.monospace.unconstrained.asciidoc', 'markup.raw.monospace.asciidoc']
      expect(tokens[3]).toEqual value: '``', scopes: ['source.asciidoc', 'markup.monospace.unconstrained.asciidoc', 'punctuation.definition.raw.asciidoc']
      expect(tokens[4]).toEqual value: ' renders exactly as entered, in mono', scopes: ['source.asciidoc']
      expect(tokens[5]).toEqual value: '``', scopes: ['source.asciidoc', 'markup.monospace.unconstrained.asciidoc', 'punctuation.definition.raw.asciidoc']
      expect(tokens[6]).toEqual value: 'space', scopes: ['source.asciidoc', 'markup.monospace.unconstrained.asciidoc', 'markup.raw.monospace.asciidoc']
      expect(tokens[7]).toEqual value: '``', scopes: ['source.asciidoc', 'markup.monospace.unconstrained.asciidoc', 'punctuation.definition.raw.asciidoc']
      expect(tokens[8]).toEqual value: '.', scopes: ['source.asciidoc']

    it 'when having a [role] set on unconstrained ``monospace`` text', ->
      {tokens} = grammar.tokenizeLine '[role]``monospace``'
      expect(tokens).toHaveLength 4
      expect(tokens[0]).toEqual value: '[role]', scopes: ['source.asciidoc', 'markup.monospace.unconstrained.asciidoc', 'markup.meta.attrlist.asciidoc']
      expect(tokens[1]).toEqual value: '``', scopes: ['source.asciidoc', 'markup.monospace.unconstrained.asciidoc', 'punctuation.definition.raw.asciidoc']
      expect(tokens[2]).toEqual value: 'monospace', scopes: ['source.asciidoc', 'markup.monospace.unconstrained.asciidoc', 'markup.raw.monospace.asciidoc']
      expect(tokens[3]).toEqual value: '``', scopes: ['source.asciidoc', 'markup.monospace.unconstrained.asciidoc', 'punctuation.definition.raw.asciidoc']

    it 'when having [role1 role2] set on unconstrained ``monospace`` text', ->
      {tokens} = grammar.tokenizeLine '[role1 role2]``monospace``'
      expect(tokens).toHaveLength 4
      expect(tokens[0]).toEqual value: '[role1 role2]', scopes: ['source.asciidoc', 'markup.monospace.unconstrained.asciidoc', 'markup.meta.attrlist.asciidoc']
      expect(tokens[1]).toEqual value: '``', scopes: ['source.asciidoc', 'markup.monospace.unconstrained.asciidoc', 'punctuation.definition.raw.asciidoc']
      expect(tokens[2]).toEqual value: 'monospace', scopes: ['source.asciidoc', 'markup.monospace.unconstrained.asciidoc', 'markup.raw.monospace.asciidoc']
      expect(tokens[3]).toEqual value: '``', scopes: ['source.asciidoc', 'markup.monospace.unconstrained.asciidoc', 'punctuation.definition.raw.asciidoc']