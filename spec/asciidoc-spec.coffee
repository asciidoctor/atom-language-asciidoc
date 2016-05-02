describe "AsciiDoc grammar", ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage "language-asciidoc"

    runs ->
      grammar = atom.grammars.grammarForScopeName "source.asciidoc"

  # convenience function during development
  debug = (tokens) ->
    console.log(JSON.stringify tokens, null, ' ')

  it "parses the grammar", ->
    expect(grammar).toBeDefined()
    expect(grammar.scopeName).toBe "source.asciidoc"

  it "does not tokenizes email addresses as URLs", ->
    {tokens} = grammar.tokenizeLine "John Smith <johnSmith@example.com>"
    expect(tokens[0]).toEqual value: "John Smith <johnSmith@example.com>", scopes: ["source.asciidoc"]

  it "tokenizes [[blockId]] elements", ->
    {tokens} = grammar.tokenizeLine "this is a [[blockId]] element"
    expect(tokens[0]).toEqual value: "this is a ", scopes: ["source.asciidoc"]
    expect(tokens[1]).toEqual value: "[[", scopes: ["source.asciidoc", "support.constant.asciidoc"]
    expect(tokens[2]).toEqual value: "blockId", scopes: ["source.asciidoc", "markup.blockid.asciidoc"]
    expect(tokens[3]).toEqual value: "]]", scopes: ["source.asciidoc", "support.constant.asciidoc"]
    expect(tokens[4]).toEqual value: " element", scopes: ["source.asciidoc"]

  it "tokenizes block titles", ->
    {tokens} = grammar.tokenizeLine """
                                    .An e-xample' e_xample
                                    =========
                                    Example
                                    =========
                                    """
    expect(tokens[1]).toEqual value: "An e-xample' e_xample", scopes: ["source.asciidoc", "markup.heading.blocktitle.asciidoc"]

  it "tokenizes explicit paragraph styles", ->
    {tokens} = grammar.tokenizeLine "[NOTE]\n====\n"
    expect(tokens[1]).toEqual value: "NOTE", scopes: ["source.asciidoc", "markup.explicit.asciidoc", "support.constant.asciidoc"]
    expect(tokens[4]).toEqual value: "====", scopes: ["source.asciidoc", "markup.block.example.asciidoc"]

  it "tokenizes section templates", ->
    {tokens} = grammar.tokenizeLine "[sect1]\nThis is an section.\n"
    expect(tokens[1]).toEqual value: "sect1", scopes: ["source.asciidoc", "markup.section.asciidoc", "support.constant.asciidoc"]
    expect(tokens[3]).toEqual value: "\nThis is an section.\n", scopes: ["source.asciidoc"]

  it "tokenizes quote declarations with attribution", ->
    {tokens} = grammar.tokenizeLine "[verse, Homer Simpson]\n"
    expect(tokens[1]).toEqual value: "verse", scopes: ["source.asciidoc", "markup.quote.declaration.asciidoc"]
    expect(tokens[3]).toEqual value: "Homer Simpson", scopes: ["source.asciidoc", "markup.quote.attribution.asciidoc"]

  it "tokenizes quote declarations with attribution and citation", ->
    {tokens} = grammar.tokenizeLine "[quote, Erwin Schrödinger, Sorry]\n"
    expect(tokens[1]).toEqual value: "quote", scopes: ["source.asciidoc", "markup.quote.declaration.asciidoc"]
    expect(tokens[3]).toEqual value: "Erwin Schrödinger", scopes: ["source.asciidoc", "markup.quote.attribution.asciidoc"]
    expect(tokens[5]).toEqual value: "Sorry", scopes: ["source.asciidoc", "markup.quote.citation.asciidoc"]
