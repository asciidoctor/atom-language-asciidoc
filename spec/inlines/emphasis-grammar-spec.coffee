describe '_emphasis_ text', ->
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

  describe 'Should tokenizes constrained _emphasis_ text when', ->

    it 'is in a phrase', ->
      {tokens} = grammar.tokenizeLine 'this is _emphasis_ text'
      expect(tokens).toHaveLength 5
      expect(tokens[0]).toEqual value: 'this is ', scopes: ['source.asciidoc']
      expect(tokens[1]).toEqual value: '_', scopes: ['source.asciidoc', 'markup.emphasis.constrained.asciidoc', 'punctuation.definition.italic.asciidoc']
      expect(tokens[2]).toEqual value: 'emphasis', scopes: ['source.asciidoc', 'markup.emphasis.constrained.asciidoc', 'markup.italic.emphasis.asciidoc']
      expect(tokens[3]).toEqual value: '_', scopes: ['source.asciidoc', 'markup.emphasis.constrained.asciidoc', 'punctuation.definition.italic.asciidoc']
      expect(tokens[4]).toEqual value: ' text', scopes: ['source.asciidoc']

    it 'contains text with underscores', ->
      {tokens} = grammar.tokenizeLine 'this is _emphasis_text_ with underscores'
      expect(tokens).toHaveLength 5
      expect(tokens[0]).toEqual value: 'this is ', scopes: ['source.asciidoc']
      expect(tokens[1]).toEqual value: '_', scopes: ['source.asciidoc', 'markup.emphasis.constrained.asciidoc', 'punctuation.definition.italic.asciidoc']
      expect(tokens[2]).toEqual value: 'emphasis_text', scopes: ['source.asciidoc', 'markup.emphasis.constrained.asciidoc', 'markup.italic.emphasis.asciidoc']
      expect(tokens[3]).toEqual value: '_', scopes: ['source.asciidoc', 'markup.emphasis.constrained.asciidoc', 'punctuation.definition.italic.asciidoc']
      expect(tokens[4]).toEqual value: ' with underscores', scopes: ['source.asciidoc']

    it 'tokenizes _emphasis_ text at the beginning of the line', ->
      {tokens} = grammar.tokenizeLine '_emphasis text_ from the start.'
      expect(tokens).toHaveLength 4
      expect(tokens[0]).toEqual value: '_', scopes: ['source.asciidoc', 'markup.emphasis.constrained.asciidoc', 'punctuation.definition.italic.asciidoc']
      expect(tokens[1]).toEqual value: 'emphasis text', scopes: ['source.asciidoc', 'markup.emphasis.constrained.asciidoc', 'markup.italic.emphasis.asciidoc']
      expect(tokens[2]).toEqual value: '_', scopes: ['source.asciidoc', 'markup.emphasis.constrained.asciidoc', 'punctuation.definition.italic.asciidoc']
      expect(tokens[3]).toEqual value: ' from the start.', scopes: ['source.asciidoc']

    it 'tokenizes _emphasis_ text in a * bulleted list', ->
      {tokens} = grammar.tokenizeLine '* _emphasis text_ followed by normal text'
      expect(tokens).toHaveLength 6
      expect(tokens[0]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.list.asciidoc', 'markup.list.bullet.asciidoc']
      expect(tokens[1]).toEqual value: ' ', scopes: ['source.asciidoc']
      expect(tokens[2]).toEqual value: '_', scopes: ['source.asciidoc', 'markup.emphasis.constrained.asciidoc', 'punctuation.definition.italic.asciidoc']
      expect(tokens[3]).toEqual value: 'emphasis text', scopes: ['source.asciidoc', 'markup.emphasis.constrained.asciidoc', 'markup.italic.emphasis.asciidoc']
      expect(tokens[4]).toEqual value: '_', scopes: ['source.asciidoc', 'markup.emphasis.constrained.asciidoc', 'punctuation.definition.italic.asciidoc']
      expect(tokens[5]).toEqual value: ' followed by normal text', scopes: ['source.asciidoc']

    it 'tokenizes constrained _emphasis_ text within special characters', ->
      {tokens} = grammar.tokenizeLine 'a_non-emphasis_a, !_emphasis_?, \'_emphasis_:, ._emphasis_; ,_emphasis_'
      expect(tokens).toHaveLength 16
      expect(tokens[0]).toEqual value: 'a_non-emphasis_a, !', scopes: ['source.asciidoc']
      expect(tokens[1]).toEqual value: '_', scopes: ['source.asciidoc', 'markup.emphasis.constrained.asciidoc', 'punctuation.definition.italic.asciidoc']
      expect(tokens[2]).toEqual value: 'emphasis', scopes: ['source.asciidoc', 'markup.emphasis.constrained.asciidoc', 'markup.italic.emphasis.asciidoc']
      expect(tokens[3]).toEqual value: '_', scopes: ['source.asciidoc', 'markup.emphasis.constrained.asciidoc', 'punctuation.definition.italic.asciidoc']
      expect(tokens[4]).toEqual value: '?, \'', scopes: ['source.asciidoc']
      expect(tokens[5]).toEqual value: '_', scopes: ['source.asciidoc', 'markup.emphasis.constrained.asciidoc', 'punctuation.definition.italic.asciidoc']
      expect(tokens[6]).toEqual value: 'emphasis', scopes: ['source.asciidoc', 'markup.emphasis.constrained.asciidoc', 'markup.italic.emphasis.asciidoc']
      expect(tokens[7]).toEqual value: '_', scopes: ['source.asciidoc', 'markup.emphasis.constrained.asciidoc', 'punctuation.definition.italic.asciidoc']
      expect(tokens[8]).toEqual value: ':, .', scopes: ['source.asciidoc']
      expect(tokens[9]).toEqual value: '_', scopes: ['source.asciidoc', 'markup.emphasis.constrained.asciidoc', 'punctuation.definition.italic.asciidoc']
      expect(tokens[10]).toEqual value: 'emphasis', scopes: ['source.asciidoc', 'markup.emphasis.constrained.asciidoc', 'markup.italic.emphasis.asciidoc']
      expect(tokens[11]).toEqual value: '_', scopes: ['source.asciidoc', 'markup.emphasis.constrained.asciidoc', 'punctuation.definition.italic.asciidoc']
      expect(tokens[12]).toEqual value: '; ,', scopes: ['source.asciidoc']
      expect(tokens[13]).toEqual value: '_', scopes: ['source.asciidoc', 'markup.emphasis.constrained.asciidoc', 'punctuation.definition.italic.asciidoc']
      expect(tokens[14]).toEqual value: 'emphasis', scopes: ['source.asciidoc', 'markup.emphasis.constrained.asciidoc', 'markup.italic.emphasis.asciidoc']
      expect(tokens[15]).toEqual value: '_', scopes: ['source.asciidoc', 'markup.emphasis.constrained.asciidoc', 'punctuation.definition.italic.asciidoc']

    it 'when having a [role] set on constrained _emphasis_ text', ->
      {tokens} = grammar.tokenizeLine '[role]_emphasis_'
      expect(tokens).toHaveLength 4
      expect(tokens[0]).toEqual value: '[role]', scopes: ['source.asciidoc', 'markup.emphasis.constrained.asciidoc', 'markup.meta.attrlist.asciidoc']
      expect(tokens[1]).toEqual value: '_', scopes: ['source.asciidoc', 'markup.emphasis.constrained.asciidoc', 'punctuation.definition.italic.asciidoc']
      expect(tokens[2]).toEqual value: 'emphasis', scopes: ['source.asciidoc', 'markup.emphasis.constrained.asciidoc', 'markup.italic.emphasis.asciidoc']
      expect(tokens[3]).toEqual value: '_', scopes: ['source.asciidoc', 'markup.emphasis.constrained.asciidoc', 'punctuation.definition.italic.asciidoc']

    it 'when having [role1 role2] set on constrained _emphasis_ text', ->
      {tokens} = grammar.tokenizeLine '[role1 role2]_emphasis_'
      expect(tokens).toHaveLength 4
      expect(tokens[0]).toEqual value: '[role1 role2]', scopes: ['source.asciidoc', 'markup.emphasis.constrained.asciidoc', 'markup.meta.attrlist.asciidoc']
      expect(tokens[1]).toEqual value: '_', scopes: ['source.asciidoc', 'markup.emphasis.constrained.asciidoc', 'punctuation.definition.italic.asciidoc']
      expect(tokens[2]).toEqual value: 'emphasis', scopes: ['source.asciidoc', 'markup.emphasis.constrained.asciidoc', 'markup.italic.emphasis.asciidoc']
      expect(tokens[3]).toEqual value: '_', scopes: ['source.asciidoc', 'markup.emphasis.constrained.asciidoc', 'punctuation.definition.italic.asciidoc']

  describe 'Should tokenizes unconstrained __emphasis__ text when', ->

    it 'tokenizes __emphasis__ text', ->
      {tokens} = grammar.tokenizeLine 'this is__emphasis__text'
      expect(tokens).toHaveLength 5
      expect(tokens[0]).toEqual value: 'this is', scopes: ['source.asciidoc']
      expect(tokens[1]).toEqual value: '__', scopes: ['source.asciidoc', 'markup.emphasis.unconstrained.asciidoc', 'punctuation.definition.italic.asciidoc']
      expect(tokens[2]).toEqual value: 'emphasis', scopes: ['source.asciidoc', 'markup.emphasis.unconstrained.asciidoc', 'markup.italic.emphasis.asciidoc']
      expect(tokens[3]).toEqual value: '__', scopes: ['source.asciidoc', 'markup.emphasis.unconstrained.asciidoc', 'punctuation.definition.italic.asciidoc']
      expect(tokens[4]).toEqual value: 'text', scopes: ['source.asciidoc']

    it 'when having a [role] set on unconstrained __emphasis__ text', ->
      {tokens} = grammar.tokenizeLine '[role]__emphasis__'
      expect(tokens).toHaveLength 4
      expect(tokens[0]).toEqual value: '[role]', scopes: ['source.asciidoc', 'markup.emphasis.unconstrained.asciidoc', 'markup.meta.attrlist.asciidoc']
      expect(tokens[1]).toEqual value: '__', scopes: ['source.asciidoc', 'markup.emphasis.unconstrained.asciidoc', 'punctuation.definition.italic.asciidoc']
      expect(tokens[2]).toEqual value: 'emphasis', scopes: ['source.asciidoc', 'markup.emphasis.unconstrained.asciidoc', 'markup.italic.emphasis.asciidoc']
      expect(tokens[3]).toEqual value: '__', scopes: ['source.asciidoc', 'markup.emphasis.unconstrained.asciidoc', 'punctuation.definition.italic.asciidoc']

    it 'when having [role1 role2] set on unconstrained _emphasis__ text', ->
      {tokens} = grammar.tokenizeLine '[role1 role2]__emphasis__'
      expect(tokens).toHaveLength 4
      expect(tokens[0]).toEqual value: '[role1 role2]', scopes: ['source.asciidoc', 'markup.emphasis.unconstrained.asciidoc', 'markup.meta.attrlist.asciidoc']
      expect(tokens[1]).toEqual value: '__', scopes: ['source.asciidoc', 'markup.emphasis.unconstrained.asciidoc', 'punctuation.definition.italic.asciidoc']
      expect(tokens[2]).toEqual value: 'emphasis', scopes: ['source.asciidoc', 'markup.emphasis.unconstrained.asciidoc', 'markup.italic.emphasis.asciidoc']
      expect(tokens[3]).toEqual value: '__', scopes: ['source.asciidoc', 'markup.emphasis.unconstrained.asciidoc', 'punctuation.definition.italic.asciidoc']
