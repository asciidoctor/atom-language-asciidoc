describe "AsciiDoc grammar", ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage("language-asciidoc")

    runs ->
      grammar = atom.syntax.grammarForScopeName("source.asciidoc")

  it "parses the grammar", ->
    expect(grammar).toBeDefined()
    expect(grammar.scopeName).toBe "source.asciidoc"

  it "tokenizes *bold* text", ->
    {tokens} = grammar.tokenizeLine("this is *bold* text")
    expect(tokens[0]).toEqual value: "this is ", scopes: ["source.asciidoc"]
    expect(tokens[1]).toEqual value: "*bold*", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
    expect(tokens[2]).toEqual value: " text", scopes: ["source.asciidoc"]

  it "tokenizes _italic_ text", ->
    {tokens} = grammar.tokenizeLine("this is _italic_ text")
    expect(tokens[0]).toEqual value: "this is ", scopes: ["source.asciidoc"]
    expect(tokens[1]).toEqual value: "_italic_", scopes: ["source.asciidoc", "markup.italic.asciidoc"]
    expect(tokens[2]).toEqual value: " text", scopes: ["source.asciidoc"]

  it "tokenizes AsciiDoc-style headings", ->
    {tokens} = grammar.tokenizeLine("= Heading 0")
    expect(tokens[0]).toEqual value: "= ", scopes: ["source.asciidoc", "markup.heading.asciidoc"]
    expect(tokens[1]).toEqual value: "Heading 0", scopes: ["source.asciidoc", "markup.heading.asciidoc"]

    {tokens} = grammar.tokenizeLine("== Heading 1")
    expect(tokens[0]).toEqual value: "== ", scopes: ["source.asciidoc", "markup.heading.asciidoc"]
    expect(tokens[1]).toEqual value: "Heading 1", scopes: ["source.asciidoc", "markup.heading.asciidoc"]

    {tokens} = grammar.tokenizeLine("=== Heading 2")
    expect(tokens[0]).toEqual value: "=== ", scopes: ["source.asciidoc", "markup.heading.asciidoc"]
    expect(tokens[1]).toEqual value: "Heading 2", scopes: ["source.asciidoc", "markup.heading.asciidoc"]

    {tokens} = grammar.tokenizeLine("==== Heading 3")
    expect(tokens[0]).toEqual value: "==== ", scopes: ["source.asciidoc", "markup.heading.asciidoc"]
    expect(tokens[1]).toEqual value: "Heading 3", scopes: ["source.asciidoc", "markup.heading.asciidoc"]

    {tokens} = grammar.tokenizeLine("===== Heading 4")
    expect(tokens[0]).toEqual value: "===== ", scopes: ["source.asciidoc", "markup.heading.asciidoc"]
    expect(tokens[1]).toEqual value: "Heading 4", scopes: ["source.asciidoc", "markup.heading.asciidoc"]

    {tokens} = grammar.tokenizeLine("====== Heading 5")
    expect(tokens[0]).toEqual value: "====== ", scopes: ["source.asciidoc", "markup.heading.asciidoc"]
    expect(tokens[1]).toEqual value: "Heading 5", scopes: ["source.asciidoc", "markup.heading.asciidoc"]
