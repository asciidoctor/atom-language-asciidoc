describe 'Admonition paragraph', ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage 'language-asciidoc'

    runs ->
      grammar = atom.grammars.grammarForScopeName 'source.asciidoc'

  it 'parses the grammar', ->
    expect(grammar).toBeDefined()
    expect(grammar.scopeName).toBe 'source.asciidoc'

  describe 'Should tokenizes when', ->

    it 'start with NOTE:', ->
      {tokens} = grammar.tokenizeLine 'NOTE: This is a note'
      expect(tokens).toHaveLength 3
      expect(tokens[0]).toEqualJson value: 'NOTE', scopes: ['source.asciidoc', 'markup.admonition.asciidoc', 'entity.name.function.asciidoc']
      expect(tokens[1]).toEqualJson value: ': ', scopes: ['source.asciidoc', 'markup.admonition.asciidoc']
      expect(tokens[2]).toEqualJson value: 'This is a note', scopes: ['source.asciidoc', 'markup.admonition.asciidoc']

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
      expect(tokens[0][0]).toEqualJson value: 'foobar', scopes: ['source.asciidoc']
      expect(tokens[1]).toHaveLength 1
      expect(tokens[1][0]).toEqualJson value: '', scopes: ['source.asciidoc']
      expect(tokens[2]).toHaveLength 3
      expect(tokens[2][0]).toEqualJson value: 'NOTE', scopes: ['source.asciidoc', 'markup.admonition.asciidoc', 'entity.name.function.asciidoc']
      expect(tokens[2][1]).toEqualJson value: ': ', scopes: ['source.asciidoc', 'markup.admonition.asciidoc']
      expect(tokens[2][2]).toEqualJson value: 'An admonition paragraph draws the reader\'s attention to', scopes: ['source.asciidoc', 'markup.admonition.asciidoc']
      expect(tokens[3]).toHaveLength 1
      expect(tokens[3][0]).toEqualJson value: 'auxiliary information.', scopes: ['source.asciidoc', 'markup.admonition.asciidoc']
      expect(tokens[4]).toHaveLength 5
      expect(tokens[4][0]).toEqualJson value: 'Its purpose is ', scopes: ['source.asciidoc', 'markup.admonition.asciidoc']
      expect(tokens[4][1]).toEqualJson value: '*', scopes: ['source.asciidoc', 'markup.admonition.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[4][2]).toEqualJson value: 'determined', scopes: ['source.asciidoc', 'markup.admonition.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc']
      expect(tokens[4][3]).toEqualJson value: '*', scopes: ['source.asciidoc', 'markup.admonition.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[4][4]).toEqualJson value: ' by the label', scopes: ['source.asciidoc', 'markup.admonition.asciidoc']
      expect(tokens[5]).toHaveLength 5
      expect(tokens[5][0]).toEqualJson value: 'at the ', scopes: ['source.asciidoc', 'markup.admonition.asciidoc']
      expect(tokens[5][1]).toEqualJson value: '_', scopes: ['source.asciidoc', 'markup.admonition.asciidoc', 'markup.emphasis.constrained.asciidoc', 'markup.italic.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[5][2]).toEqualJson value: 'beginning', scopes: ['source.asciidoc', 'markup.admonition.asciidoc', 'markup.emphasis.constrained.asciidoc', 'markup.italic.asciidoc']
      expect(tokens[5][3]).toEqualJson value: '_', scopes: ['source.asciidoc', 'markup.admonition.asciidoc', 'markup.emphasis.constrained.asciidoc', 'markup.italic.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[5][4]).toEqualJson value: ' of the paragraph.', scopes: ['source.asciidoc', 'markup.admonition.asciidoc']
      expect(tokens[6]).toHaveLength 1
      expect(tokens[6][0]).toEqualJson value: '', scopes: ['source.asciidoc']
      expect(tokens[7]).toHaveLength 1
      expect(tokens[7][0]).toEqualJson value: 'foobar', scopes: ['source.asciidoc']

    it 'start with TIP:', ->
      {tokens} = grammar.tokenizeLine 'TIP: Pro tip...'
      expect(tokens).toHaveLength 3
      expect(tokens[0]).toEqualJson value: 'TIP', scopes: ['source.asciidoc', 'markup.admonition.asciidoc', 'entity.name.function.asciidoc']
      expect(tokens[1]).toEqualJson value: ': ', scopes: ['source.asciidoc', 'markup.admonition.asciidoc']
      expect(tokens[2]).toEqualJson value: 'Pro tip...', scopes: ['source.asciidoc', 'markup.admonition.asciidoc']

    it 'start with IMPORTANT:', ->
      {tokens} = grammar.tokenizeLine 'IMPORTANT: Don\'t forget...'
      expect(tokens).toHaveLength 3
      expect(tokens[0]).toEqualJson value: 'IMPORTANT', scopes: ['source.asciidoc', 'markup.admonition.asciidoc', 'entity.name.function.asciidoc']
      expect(tokens[1]).toEqualJson value: ': ', scopes: ['source.asciidoc', 'markup.admonition.asciidoc']
      expect(tokens[2]).toEqualJson value: 'Don\'t forget...', scopes: ['source.asciidoc', 'markup.admonition.asciidoc']

    it 'start with WARNING:', ->
      {tokens} = grammar.tokenizeLine 'WARNING: Watch out for...'
      expect(tokens).toHaveLength 3
      expect(tokens[0]).toEqualJson value: 'WARNING', scopes: ['source.asciidoc', 'markup.admonition.asciidoc', 'entity.name.function.asciidoc']
      expect(tokens[1]).toEqualJson value: ': ', scopes: ['source.asciidoc', 'markup.admonition.asciidoc']
      expect(tokens[2]).toEqualJson value: 'Watch out for...', scopes: ['source.asciidoc', 'markup.admonition.asciidoc']

    it 'start with CAUTION:', ->
      {tokens} = grammar.tokenizeLine 'CAUTION: Ensure that...'
      expect(tokens).toHaveLength 3
      expect(tokens[0]).toEqualJson value: 'CAUTION', scopes: ['source.asciidoc', 'markup.admonition.asciidoc', 'entity.name.function.asciidoc']
      expect(tokens[1]).toEqualJson value: ': ', scopes: ['source.asciidoc', 'markup.admonition.asciidoc']
      expect(tokens[2]).toEqualJson value: 'Ensure that...', scopes: ['source.asciidoc', 'markup.admonition.asciidoc']

  describe 'Should not tokenizes when', ->

    it 'beginning with space', ->
      {tokens} = grammar.tokenizeLine ' CAUTION: Ensure that...'
      expect(tokens).toHaveLength 1
      expect(tokens[0]).toEqualJson value: ' CAUTION: Ensure that...', scopes: ['source.asciidoc']
