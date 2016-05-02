describe 'Titles', ->
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

  describe 'description', ->

    asciidocHeadersChecker = (level) ->
      equalsSigns = level + 1
      marker = Array(equalsSigns + 1).join('=')
      {tokens} = grammar.tokenizeLine "#{marker} Heading #{level}"
      expect(tokens[0]).toEqual value: "#{marker} ", scopes: ['source.asciidoc', 'markup.heading.asciidoc']
      expect(tokens[1]).toEqual value: "Heading #{level}", scopes: ['source.asciidoc', 'markup.heading.asciidoc']

    it 'tokenizes AsciiDoc-style headings', ->
      asciidocHeadersChecker(level) for level in [0..5]

  describe 'Should tokenizes Mardown-style headings when', ->

    it 'was a level 0', ->
      {tokens} = grammar.tokenizeLine '# Heading 0'
      expect(tokens).toHaveLength 2
      expect(tokens[0]).toEqual value: '# ', scopes: ['source.asciidoc', 'markup.heading.asciidoc']
      expect(tokens[1]).toEqual value: 'Heading 0', scopes: ['source.asciidoc', 'markup.heading.asciidoc']

    it 'was a level 1', ->
      {tokens} = grammar.tokenizeLine '## Heading 1'
      expect(tokens).toHaveLength 2
      expect(tokens[0]).toEqual value: '## ', scopes: ['source.asciidoc', 'markup.heading.asciidoc']
      expect(tokens[1]).toEqual value: 'Heading 1', scopes: ['source.asciidoc', 'markup.heading.asciidoc']

    it 'was a level 2', ->
      {tokens} = grammar.tokenizeLine '### Heading 2'
      expect(tokens).toHaveLength 2
      expect(tokens[0]).toEqual value: '### ', scopes: ['source.asciidoc', 'markup.heading.asciidoc']
      expect(tokens[1]).toEqual value: 'Heading 2', scopes: ['source.asciidoc', 'markup.heading.asciidoc']

    it 'was a level 3', ->
      {tokens} = grammar.tokenizeLine '#### Heading 3'
      expect(tokens).toHaveLength 2
      expect(tokens[0]).toEqual value: '#### ', scopes: ['source.asciidoc', 'markup.heading.asciidoc']
      expect(tokens[1]).toEqual value: 'Heading 3', scopes: ['source.asciidoc', 'markup.heading.asciidoc']

    it 'was a level 4', ->
      {tokens} = grammar.tokenizeLine '##### Heading 4'
      expect(tokens[0]).toEqual value: '##### ', scopes: ['source.asciidoc', 'markup.heading.asciidoc']
      expect(tokens[1]).toEqual value: 'Heading 4', scopes: ['source.asciidoc', 'markup.heading.asciidoc']

    it 'was a level 5', ->
      {tokens} = grammar.tokenizeLine '###### Heading 5'
      expect(tokens).toHaveLength 2
      expect(tokens[0]).toEqual value: '###### ', scopes: ['source.asciidoc', 'markup.heading.asciidoc']
      expect(tokens[1]).toEqual value: 'Heading 5', scopes: ['source.asciidoc', 'markup.heading.asciidoc']
