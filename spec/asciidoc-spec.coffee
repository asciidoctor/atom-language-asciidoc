describe "AsciiDoc grammar", ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage("language-asciidoc")

    runs ->
      grammar = atom.grammars.grammarForScopeName("source.asciidoc")

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

  testAsciidocHeaders = (level) ->
    equalsSigns = level + 1
    marker = Array(equalsSigns + 1).join('=')
    {tokens} = grammar.tokenizeLine("#{marker} Heading #{level}")
    expect(tokens[0]).toEqual value: "#{marker} ", scopes: ["source.asciidoc", "markup.heading.asciidoc"]
    expect(tokens[1]).toEqual value: "Heading #{level}", scopes: ["source.asciidoc", "markup.heading.asciidoc"]

  it "tokenizes AsciiDoc-style headings", ->
    testAsciidocHeaders(level) for level in [0..5]

  it "tokenizes list bullets with the length up to 5 symbols", ->
    {tokens} = grammar.tokenizeLine("""
                                    . Level 1
                                    .. Level 2
                                    *** Level 3
                                    **** Level 4
                                    ***** Level 5
                                    """)
    expect(tokens[0]).toEqual  value: ".", scopes: ["source.asciidoc", "markup.list.asciidoc", "markup.list.bullet.asciidoc"]
    expect(tokens[3]).toEqual  value: "..", scopes: ["source.asciidoc", "markup.list.asciidoc", "markup.list.bullet.asciidoc"]
    expect(tokens[6]).toEqual  value: "***", scopes: ["source.asciidoc", "markup.list.asciidoc", "markup.list.bullet.asciidoc"]
    expect(tokens[9]).toEqual  value: "****", scopes: ["source.asciidoc", "markup.list.asciidoc", "markup.list.bullet.asciidoc"]
    expect(tokens[12]).toEqual value: "*****", scopes: ["source.asciidoc", "markup.list.asciidoc", "markup.list.bullet.asciidoc"]

  it "tokenizes table delimited block", ->
    {tokens} = grammar.tokenizeLine("|===\n|===")
    expect(tokens[0]).toEqual value: "|===", scopes: ["source.asciidoc", "support.table.asciidoc"]
    expect(tokens[2]).toEqual value: "|===", scopes: ["source.asciidoc", "support.table.asciidoc"]

  it "ignores table delimited block with less than 3 equal signs", ->
    {tokens} = grammar.tokenizeLine("|==\n|==")
    expect(tokens[0]).toEqual value: "|==\n|==", scopes: ["source.asciidoc"]

  it "tokenizes cell delimiters within table block", ->
    {tokens} = grammar.tokenizeLine("|===\n|Name h|Purpose\n|===")
    expect(tokens[2]).toEqual value: "|", scopes: ["source.asciidoc", "support.table.asciidoc"]
    expect(tokens[6]).toEqual value: "|", scopes: ["source.asciidoc", "support.table.asciidoc"]

  it "tokenizes cell specs within table block", ->
    {tokens} = grammar.tokenizeLine("|===\n^|1 2.2+^.^|2 .3+<.>m|3\n|===")
    expect(tokens[2]).toEqual value: "^", scopes: ["source.asciidoc", "support.table.spec.asciidoc"]
    expect(tokens[6]).toEqual value: "2.2+^.^", scopes: ["source.asciidoc", "support.table.spec.asciidoc"]
    expect(tokens[10]).toEqual value: ".3+<.>m", scopes: ["source.asciidoc", "support.table.spec.asciidoc"]

  it "tokenizes admonition", ->
    {tokens} = grammar.tokenizeLine("NOTE: This is a note")
    expect(tokens[0]).toEqual value: "NOTE:", scopes: ["source.asciidoc", "markup.admonition.asciidoc", "support.constant.asciidoc"]
    expect(tokens[2]).toEqual value: "This is a note", scopes: ["source.asciidoc", "markup.admonition.asciidoc"]

  it "tokenizes explicit paragraph style", ->
    {tokens} = grammar.tokenizeLine("[NOTE]\n====\n")
    expect(tokens[1]).toEqual value: "NOTE", scopes: ["source.asciidoc", "markup.explicitStyle.asciidoc", "support.constant.asciidoc"]
    expect(tokens[3]).toEqual value: "====", scopes: ["source.asciidoc", "markup.explicitStyle.asciidoc"]

  it "tokenizes quote blocks", ->
    {tokens} = grammar.tokenizeLine("[quote]\n____\nD'oh!\n____")
    expect(tokens[1]).toEqual value: "quote", scopes: ["source.asciidoc", "quote.declaration.asciidoc"]
    expect(tokens[4]).toEqual value: "____", scopes: ["source.asciidoc", "quote.block.asciidoc"]
    expect(tokens[6]).toEqual value: "____", scopes: ["source.asciidoc", "quote.block.asciidoc"]

  it "tokenizes quote blocks with attribution", ->
    {tokens} = grammar.tokenizeLine("[verse, Homer Simpson]\n____\nD'oh!\n____")
    expect(tokens[1]).toEqual value: "verse", scopes: ["source.asciidoc", "quote.declaration.asciidoc"]
    expect(tokens[3]).toEqual value: "Homer Simpson", scopes: ["source.asciidoc", "quote.attribution.asciidoc"]

  it "tokenizes quote blocks with attribution and citation", ->
    {tokens} = grammar.tokenizeLine("[quote, Erwin Schrödinger, Sorry]\n")
    expect(tokens[1]).toEqual value: "quote", scopes: ["source.asciidoc", "quote.declaration.asciidoc"]
    expect(tokens[3]).toEqual value: "Erwin Schrödinger", scopes: ["source.asciidoc", "quote.attribution.asciidoc"]
    expect(tokens[5]).toEqual value: "Sorry", scopes: ["source.asciidoc", "quote.citation.asciidoc"]

  testBlock = (delimiter,type) ->
    marker = Array(5).join(delimiter)
    {tokens} = grammar.tokenizeLine("#{marker}\ncontent\n#{marker}")
    expect(tokens[0]).toEqual value: marker, scopes: ["source.asciidoc", type]
    expect(tokens[2]).toEqual value: marker, scopes: ["source.asciidoc", type]

  it "tokenizes comment block", ->
    testBlock "/", "comment.block.asciidoc"

  it "tokenizes example block", ->
    testBlock "=", "example.block.asciidoc"

  it "tokenizes sidebar block", ->
    testBlock "*", "sidebar.block.asciidoc"

  it "tokenizes literal block", ->
    testBlock ".", "literal.block.asciidoc"

  it "tokenizes passthrough block", ->
    testBlock "+", "passthrough.block.asciidoc"
