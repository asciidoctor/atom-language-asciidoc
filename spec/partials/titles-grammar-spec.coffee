# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.
describe 'Titles', ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage 'language-asciidoc'

    runs ->
      grammar = atom.grammars.grammarForScopeName 'source.asciidoc'

  it 'parses the grammar', ->
    expect(grammar).toBeDefined()
    expect(grammar.scopeName).toBe 'source.asciidoc'

  describe 'asciidoc headers', ->

    asciidocHeadersChecker = (level) ->
      equalsSigns = level + 1
      marker = Array(equalsSigns + 1).join('=')
      {tokens} = grammar.tokenizeLine "#{marker} Heading #{level}"
      expect(tokens).toHaveLength 3
      expect(tokens[0]).toEqualJson value: "#{marker}", scopes: ['source.asciidoc', "markup.heading.heading-#{level}.asciidoc", 'markup.heading.marker.asciidoc']
      expect(tokens[1]).toEqualJson value: " ", scopes: ['source.asciidoc', "markup.heading.heading-#{level}.asciidoc", 'markup.heading.space.asciidoc']
      expect(tokens[2]).toEqualJson value: "Heading #{level}", scopes: ['source.asciidoc', "markup.heading.heading-#{level}.asciidoc"]

    it 'tokenizes AsciiDoc-style headings', ->
      asciidocHeadersChecker(level) for level in [0..5]

  describe 'markdown headers', ->

    markdownHeadersChecker = (level) ->
      equalsSigns = level + 1
      marker = Array(equalsSigns + 1).join('#')
      {tokens} = grammar.tokenizeLine "#{marker} Heading #{level}"
      expect(tokens).toHaveLength 3
      expect(tokens[0]).toEqualJson value: "#{marker}", scopes: ['source.asciidoc', "markup.heading.heading-#{level}.asciidoc", 'markup.heading.marker.asciidoc']
      expect(tokens[1]).toEqualJson value: " ", scopes: ['source.asciidoc', "markup.heading.heading-#{level}.asciidoc", 'markup.heading.space.asciidoc']
      expect(tokens[2]).toEqualJson value: "Heading #{level}", scopes: ['source.asciidoc', "markup.heading.heading-#{level}.asciidoc"]

    it 'tokenizes Markdown-style headings', ->
      markdownHeadersChecker(level) for level in [0..5]
