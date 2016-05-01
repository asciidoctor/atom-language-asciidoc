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

  describe 'Should tokenizes pass macro when', ->

    it 'started at the beginning of the line and without text after.', ->
      {tokens} = grammar.tokenizeLine 'pass:[text]'
      expect(tokens).toHaveLength 2
      expect(tokens[0]).toEqual value: 'pass:', scopes: ['source.asciidoc', 'markup.reference.pass.asciidoc', 'support.constant.pass.inline.asciidoc']
      expect(tokens[1]).toEqual value: '[text]', scopes: ['source.asciidoc', 'markup.reference.pass.asciidoc']

    it 'not started at the beginning of the line', ->
      {tokens} = grammar.tokenizeLine 'foo pass:[text]'
      expect(tokens).toHaveLength 1
      expect(tokens[0]).toEqual value: 'foo pass:[text]', scopes: ['source.asciidoc']

    it 'have text after', ->
      {tokens} = grammar.tokenizeLine 'pass:[text] bar'
      expect(tokens).toHaveLength 1
      expect(tokens[0]).toEqual value: 'pass:[text] bar', scopes: ['source.asciidoc']
