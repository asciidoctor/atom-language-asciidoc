describe "AsciiDoc grammar", ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage("language-asciidoc")

    runs ->
      grammar = atom.grammars.grammarForScopeName("source.asciidoc")

  # convenience function during development
  debug = (tokens) ->
    console.log(JSON.stringify(tokens, null, '\t'))

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

  it "tokenizes HTML elements", ->
    {tokens} = grammar.tokenizeLine("Dungeons &amp; Dragons")
    expect(tokens[0]).toEqual value: "Dungeons ", scopes: ["source.asciidoc"]
    expect(tokens[1]).toEqual value: "&", scopes: ["source.asciidoc", "markup.htmlentity.asciidoc", "support.constant.asciidoc"]
    expect(tokens[2]).toEqual value: "amp", scopes: ["source.asciidoc", "markup.htmlentity.asciidoc"]
    expect(tokens[3]).toEqual value: ";", scopes: ["source.asciidoc", "markup.htmlentity.asciidoc", "support.constant.asciidoc"]
    expect(tokens[4]).toEqual value: " Dragons", scopes: ["source.asciidoc"]

  it "tokenizes URLs", ->
    {tokens} = grammar.tokenizeLine("http://www.docbook.org is great")
    expect(tokens[0]).toEqual value: "http://www.docbook.org", scopes: ["source.asciidoc", "markup.underline.link.asciidoc"]

  it "does not tokenizes email addresses as URLs", ->
    {tokens} = grammar.tokenizeLine("John Smith <johnSmith@example.com>")
    expect(tokens[0]).toEqual value: "John Smith <johnSmith@example.com>", scopes: ["source.asciidoc"]

  it "tokenizes inline macros", ->
    {tokens} = grammar.tokenizeLine("http://www.docbook.org/[DocBook.org]")
    expect(tokens[0]).toEqual value: "http:", scopes: ["source.asciidoc", "markup.macro.inline.asciidoc", "support.constant.asciidoc"]
    expect(tokens[1]).toEqual value: "//www.docbook.org/", scopes: ["source.asciidoc", "markup.macro.inline.asciidoc"]
    expect(tokens[2]).toEqual value: "[", scopes: ["source.asciidoc", "markup.macro.inline.asciidoc", "support.constant.asciidoc"]
    expect(tokens[3]).toEqual value: "DocBook.org", scopes: ["source.asciidoc", "markup.macro.inline.asciidoc"]
    expect(tokens[4]).toEqual value: "]", scopes: ["source.asciidoc", "markup.macro.inline.asciidoc", "support.constant.asciidoc"]

  it "tokenizes block macros", ->
    {tokens} = grammar.tokenizeLine("image::tiger.png[Tyger tyger]")
    expect(tokens[0]).toEqual value: "image::", scopes: ["source.asciidoc", "markup.macro.block.asciidoc", "support.constant.asciidoc"]
    expect(tokens[1]).toEqual value: "tiger.png", scopes: ["source.asciidoc", "markup.macro.block.asciidoc"]
    expect(tokens[2]).toEqual value: "[", scopes: ["source.asciidoc", "markup.macro.block.asciidoc", "support.constant.asciidoc"]
    expect(tokens[3]).toEqual value: "Tyger tyger", scopes: ["source.asciidoc", "markup.macro.block.asciidoc"]
    expect(tokens[4]).toEqual value: "]", scopes: ["source.asciidoc", "markup.macro.block.asciidoc", "support.constant.asciidoc"]

  it "tokenizes [[blockId]] elements", ->
    {tokens} = grammar.tokenizeLine("this is a [[blockId]] element")
    expect(tokens[0]).toEqual value: "this is a ", scopes: ["source.asciidoc"]
    expect(tokens[1]).toEqual value: "[[", scopes: ["source.asciidoc", "support.constant.asciidoc"]
    expect(tokens[2]).toEqual value: "blockId", scopes: ["source.asciidoc", "markup.blockid.asciidoc"]
    expect(tokens[3]).toEqual value: "]]", scopes: ["source.asciidoc", "support.constant.asciidoc"]
    expect(tokens[4]).toEqual value: " element", scopes: ["source.asciidoc"]

  it "tokenizes [[[bib-ref]]] bibliography references", ->
    {tokens} = grammar.tokenizeLine("this is a [[[bib-ref]]] element")
    expect(tokens[0]).toEqual value: "this is a ", scopes: ["source.asciidoc"]
    expect(tokens[1]).toEqual value: "[[[", scopes: ["source.asciidoc", "support.constant.asciidoc"]
    expect(tokens[2]).toEqual value: "bib-ref", scopes: ["source.asciidoc", "markup.biblioref.asciidoc"]
    expect(tokens[3]).toEqual value: "]]]", scopes: ["source.asciidoc", "support.constant.asciidoc"]
    expect(tokens[4]).toEqual value: " element", scopes: ["source.asciidoc"]

  it "tokenizes <<reference>> elements", ->
    {tokens} = grammar.tokenizeLine("this is a <<reference>> element")
    expect(tokens[0]).toEqual value: "this is a ", scopes: ["source.asciidoc"]
    expect(tokens[1]).toEqual value: "<<", scopes: ["source.asciidoc", "support.constant.asciidoc"]
    expect(tokens[2]).toEqual value: "reference", scopes: ["source.asciidoc", "markup.reference.asciidoc"]
    expect(tokens[3]).toEqual value: ">>", scopes: ["source.asciidoc", "support.constant.asciidoc"]
    expect(tokens[4]).toEqual value: " element", scopes: ["source.asciidoc"]

  testAsciidocHeaders = (level) ->
    equalsSigns = level + 1
    marker = Array(equalsSigns + 1).join('=')
    {tokens} = grammar.tokenizeLine("#{marker} Heading #{level}")
    expect(tokens[0]).toEqual value: "#{marker} ", scopes: ["source.asciidoc", "markup.heading.asciidoc"]
    expect(tokens[1]).toEqual value: "Heading #{level}", scopes: ["source.asciidoc", "markup.heading.asciidoc"]

  it "tokenizes AsciiDoc-style headings", ->
    testAsciidocHeaders(level) for level in [0..5]

  it "tokenizes block titles", ->
    {tokens} = grammar.tokenizeLine("""
                                    .An example example
                                    =========
                                    Example
                                    =========
                                    """)
    expect(tokens[1]).toEqual value: "An example example", scopes: ["source.asciidoc", "markup.heading.blocktitle.asciidoc"]
    expect(tokens[3]).toEqual value: "=========", scopes: ["source.asciidoc", "markup.block.example.asciidoc"]

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

  it "tokenizes explicit paragraph styles", ->
    {tokens} = grammar.tokenizeLine("[NOTE]\n====\n")
    expect(tokens[1]).toEqual value: "NOTE", scopes: ["source.asciidoc", "markup.explicit.asciidoc", "support.constant.asciidoc"]
    expect(tokens[4]).toEqual value: "====", scopes: ["source.asciidoc", "markup.block.example.asciidoc"]

  it "tokenizes section templates", ->
    {tokens} = grammar.tokenizeLine("[sect1]\nThis is an section.\n")
    expect(tokens[1]).toEqual value: "sect1", scopes: ["source.asciidoc", "markup.section.asciidoc", "support.constant.asciidoc"]
    expect(tokens[3]).toEqual value: "\nThis is an section.\n", scopes: ["source.asciidoc"]

  it "tokenizes quote blocks", ->
    {tokens} = grammar.tokenizeLine("""
                                    [quote]
                                    ____
                                    D'oh!
                                    ____
                                    """)
    expect(tokens[1]).toEqual value: "quote", scopes: ["source.asciidoc", "markup.quote.declaration.asciidoc"]
    expect(tokens[4]).toEqual value: "____", scopes: ["source.asciidoc", "markup.quote.block.asciidoc"]
    expect(tokens[5]).toEqual value: "\nD'oh!\n", scopes: ["source.asciidoc", "markup.quote.block.asciidoc"]
    expect(tokens[6]).toEqual value: "____", scopes: ["source.asciidoc", "markup.quote.block.asciidoc"]

  it "tokenizes quote declarations with attribution", ->
    {tokens} = grammar.tokenizeLine("[verse, Homer Simpson]\n")
    expect(tokens[1]).toEqual value: "verse", scopes: ["source.asciidoc", "markup.quote.declaration.asciidoc"]
    expect(tokens[3]).toEqual value: "Homer Simpson", scopes: ["source.asciidoc", "markup.quote.attribution.asciidoc"]

  it "tokenizes quote declarations with attribution and citation", ->
    {tokens} = grammar.tokenizeLine("[quote, Erwin Schrödinger, Sorry]\n")
    expect(tokens[1]).toEqual value: "quote", scopes: ["source.asciidoc", "markup.quote.declaration.asciidoc"]
    expect(tokens[3]).toEqual value: "Erwin Schrödinger", scopes: ["source.asciidoc", "markup.quote.attribution.asciidoc"]
    expect(tokens[5]).toEqual value: "Sorry", scopes: ["source.asciidoc", "markup.quote.citation.asciidoc"]

  testBlock = (delimiter,type) ->
    marker = Array(5).join(delimiter)
    {tokens} = grammar.tokenizeLine("#{marker}\ncontent\n#{marker}")
    expect(tokens[0]).toEqual value: marker, scopes: ["source.asciidoc", type]
    expect(tokens[2]).toEqual value: marker, scopes: ["source.asciidoc", type]

  it "tokenizes comment block", ->
    testBlock "/", "comment.block.asciidoc"

  it "tokenizes example block", ->
    testBlock "=", "markup.block.example.asciidoc"

  it "tokenizes sidebar block", ->
    testBlock "*", "markup.block.sidebar.asciidoc"

  it "tokenizes literal block", ->
    testBlock ".", "markup.block.literal.asciidoc"

  it "tokenizes passthrough block", ->
    testBlock "+", "markup.block.passthrough.asciidoc"
