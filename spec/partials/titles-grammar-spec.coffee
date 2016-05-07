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

  describe 'asciidoc headers', ->

    asciidocHeadersChecker = (level) ->
      equalsSigns = level + 1
      marker = Array(equalsSigns + 1).join('=')
      {tokens} = grammar.tokenizeLine "#{marker} Heading #{level}"
      expect(tokens).toHaveLength 3
      expect(tokens[0]).toEqual value: "#{marker}", scopes: ['source.asciidoc', "markup.heading-#{level}.asciidoc", 'markup.heading.marker.asciidoc']
      expect(tokens[1]).toEqual value: " ", scopes: ['source.asciidoc', "markup.heading-#{level}.asciidoc", 'markup.heading.space.asciidoc']
      expect(tokens[2]).toEqual value: "Heading #{level}", scopes: ['source.asciidoc', "markup.heading-#{level}.asciidoc"]

    it 'tokenizes AsciiDoc-style headings', ->
      asciidocHeadersChecker(level) for level in [0..5]

  describe 'markdown headers', ->

    markdownHeadersChecker = (level) ->
      equalsSigns = level + 1
      marker = Array(equalsSigns + 1).join('#')
      {tokens} = grammar.tokenizeLine "#{marker} Heading #{level}"
      expect(tokens).toHaveLength 3
      expect(tokens[0]).toEqual value: "#{marker}", scopes: ['source.asciidoc', "markup.heading-#{level}.asciidoc", 'markup.heading.marker.asciidoc']
      expect(tokens[1]).toEqual value: " ", scopes: ['source.asciidoc', "markup.heading-#{level}.asciidoc", 'markup.heading.space.asciidoc']
      expect(tokens[2]).toEqual value: "Heading #{level}", scopes: ['source.asciidoc', "markup.heading-#{level}.asciidoc"]

    it 'tokenizes Markdown-style headings', ->
      markdownHeadersChecker(level) for level in [0..5]