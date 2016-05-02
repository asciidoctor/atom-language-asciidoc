describe 'AsciiDoc grammar', ->
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

  describe 'Should tokenizes table when', ->

    it 'table delimited block', ->
      {tokens} = grammar.tokenizeLine '|===\n|==='
      expect(tokens[0]).toEqual value: '|===', scopes: ['source.asciidoc', 'support.table.asciidoc']
      expect(tokens[2]).toEqual value: '|===', scopes: ['source.asciidoc', 'support.table.asciidoc']

    it 'ignores table delimited block with less than 3 equal signs', ->
      {tokens} = grammar.tokenizeLine '|==\n|=='
      expect(tokens[0]).toEqual value: '|==\n|==', scopes: ['source.asciidoc']

    it 'cell delimiters within table block', ->
      {tokens} = grammar.tokenizeLine '|===\n|Name h|Purpose\n|==='
      expect(tokens[2]).toEqual value: '|', scopes: ['source.asciidoc', 'support.table.asciidoc']
      expect(tokens[6]).toEqual value: '|', scopes: ['source.asciidoc', 'support.table.asciidoc']

    it 'cell specs within table block', ->
      {tokens} = grammar.tokenizeLine '|===\n^|1 2.2+^.^|2 .3+<.>m|3\n|==='
      expect(tokens[2]).toEqual value: '^', scopes: ['source.asciidoc', 'support.table.spec.asciidoc']
      expect(tokens[6]).toEqual value: '2.2+^.^', scopes: ['source.asciidoc', 'support.table.spec.asciidoc']
      expect(tokens[10]).toEqual value: '.3+<.>m', scopes: ['source.asciidoc', 'support.table.spec.asciidoc']
