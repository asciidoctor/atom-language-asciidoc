describe 'horizontal rule and page break', ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage 'language-asciidoc'

    runs ->
      grammar = atom.grammars.grammarForScopeName 'source.asciidoc'

  it 'parses the grammar', ->
    expect(grammar).toBeDefined()
    expect(grammar.scopeName).toBe 'source.asciidoc'

  describe 'Should tokenizes horizontal rule when', ->

    it 'contains quotes', ->
      {tokens} = grammar.tokenizeLine '\'\'\''
      expect(tokens).toHaveLength 1
      expect(tokens[0]).toEqualJson value: '\'\'\'', scopes: ['source.asciidoc', 'constant.other.symbol.horizontal-rule.asciidoc']

    it 'contains quotes with spaces', ->
      {tokens} = grammar.tokenizeLine '\' \' \''
      expect(tokens).toHaveLength 1
      expect(tokens[0]).toEqualJson value: '\' \' \'', scopes: ['source.asciidoc', 'constant.other.symbol.horizontal-rule.asciidoc']

    it 'contains asterisks', ->
      {tokens} = grammar.tokenizeLine '***'
      expect(tokens).toHaveLength 1
      expect(tokens[0]).toEqualJson value: '***', scopes: ['source.asciidoc', 'constant.other.symbol.horizontal-rule.asciidoc']

    it 'contains asterisks with spaces', ->
      {tokens} = grammar.tokenizeLine '* * *'
      expect(tokens).toHaveLength 1
      expect(tokens[0]).toEqualJson value: '* * *', scopes: ['source.asciidoc', 'constant.other.symbol.horizontal-rule.asciidoc']

    it 'contains hyphen', ->
      {tokens} = grammar.tokenizeLine '---'
      expect(tokens).toHaveLength 1
      expect(tokens[0]).toEqualJson value: '---', scopes: ['source.asciidoc', 'constant.other.symbol.horizontal-rule.asciidoc']

    it 'contains hyphen with spaces', ->
      {tokens} = grammar.tokenizeLine '- - -'
      expect(tokens).toHaveLength 1
      expect(tokens[0]).toEqualJson value: '- - -', scopes: ['source.asciidoc', 'constant.other.symbol.horizontal-rule.asciidoc']

  describe 'Should tokenizes page break when', ->

    it 'contains "lower than" symbol', ->
      {tokens} = grammar.tokenizeLine '<<<'
      expect(tokens).toHaveLength 1
      expect(tokens[0]).toEqualJson value: '<<<', scopes: ['source.asciidoc', 'constant.other.symbol.horizontal-rule.asciidoc']
