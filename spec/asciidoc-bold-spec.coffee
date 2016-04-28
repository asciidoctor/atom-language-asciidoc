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

  describe "Should tokenizes *bold* text", ->

    it "when constrained *bold* text", ->
      {tokens} = grammar.tokenizeLine("this is *bold* text")
      expect(tokens[0]).toEqual value: "this is ", scopes: ["source.asciidoc"]
      expect(tokens[1]).toEqual value: "*", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[2]).toEqual value: "bold", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[3]).toEqual value: "*", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[4]).toEqual value: " text", scopes: ["source.asciidoc"]

    it "when unconstrained **bold** text", ->
      {tokens} = grammar.tokenizeLine("this is**bold**text")
      expect(tokens[0]).toEqual value: "this is", scopes: ["source.asciidoc"]
      expect(tokens[1]).toEqual value: "**", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[2]).toEqual value: "bold", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[3]).toEqual value: "**", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[4]).toEqual value: "text", scopes: ["source.asciidoc"]

    it "when unconstrained **bold** text with asterisks", ->
      {tokens} = grammar.tokenizeLine("this is**bold*text**")
      expect(tokens[0]).toEqual value: "this is", scopes: ["source.asciidoc"]
      expect(tokens[1]).toEqual value: "**", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[2]).toEqual value: "bold*text", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[3]).toEqual value: "**", scopes: ["source.asciidoc", "markup.bold.asciidoc"]

    it "when multi-line constrained *bold* text", ->
      tokens = grammar.tokenizeLines("""
                                      this is *multi-
                                      line bold* text
                                      """)
      expect(tokens[0][0]).toEqual value: "this is ", scopes: ["source.asciidoc"]
      expect(tokens[0][1]).toEqual value: "*", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[0][2]).toEqual value: "multi-", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[1][0]).toEqual value: "line bold", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[1][1]).toEqual value: "*", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[1][2]).toEqual value: " text", scopes: ["source.asciidoc"]

    it "when multi-line constrained *bold* text closes on a new line", ->
      tokens = grammar.tokenizeLines("""
                                      this is *multi-
                                      line bold
                                      * text
                                      """)
      expect(tokens[0][0]).toEqual value: "this is ", scopes: ["source.asciidoc"]
      expect(tokens[0][1]).toEqual value: "*", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[0][2]).toEqual value: "multi-", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[1][0]).toEqual value: "line bold", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[2][0]).toEqual value: "*", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[2][1]).toEqual value: " text", scopes: ["source.asciidoc"]

    it "when multi-line unconstrained **bold** text", ->
      tokens = grammar.tokenizeLines("""
                                      this is**multi-
                                      line bold**text
                                      """)
      expect(tokens[0][0]).toEqual value: "this is", scopes: ["source.asciidoc"]
      expect(tokens[0][1]).toEqual value: "**", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[0][2]).toEqual value: "multi-", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[1][0]).toEqual value: "line bold", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[1][1]).toEqual value: "**", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[1][2]).toEqual value: "text", scopes: ["source.asciidoc"]

    it "when multi-line unconstrained **bold** text closes on a new line", ->
      tokens = grammar.tokenizeLines("""
                                      this is**multi-
                                      line bold
                                      **text
                                      """)
      expect(tokens[0][0]).toEqual value: "this is", scopes: ["source.asciidoc"]
      expect(tokens[0][1]).toEqual value: "**", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[0][2]).toEqual value: "multi-", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[1][0]).toEqual value: "line bold", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[2][0]).toEqual value: "**", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[2][1]).toEqual value: "text", scopes: ["source.asciidoc"]

    it "when constrained *bold* at the beginning of the line", ->
      {tokens} = grammar.tokenizeLine("*bold text* from the start.")
      expect(tokens.length).toEqual 4
      expect(tokens[0]).toEqual value: "*", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[1]).toEqual value: "bold text", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[2]).toEqual value: "*", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[3]).toEqual value: " from the start.", scopes: ["source.asciidoc"]

    it "when constrained *bold* in a * bulleted list", ->
      {tokens} = grammar.tokenizeLine("* *bold text* followed by normal text")
      expect(tokens.length).toEqual 6
      expect(tokens[0]).toEqual value: "*", scopes: ["source.asciidoc", "markup.list.asciidoc", "markup.list.bullet.asciidoc"]
      expect(tokens[1]).toEqual value: " ", scopes: ["source.asciidoc", "markup.list.asciidoc"]
      expect(tokens[2]).toEqual value: "*", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[3]).toEqual value: "bold text", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[4]).toEqual value: "*", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[5]).toEqual value: " followed by normal text", scopes: ["source.asciidoc"]

    it "when constrained *bold* text within special characters", ->
      {tokens} = grammar.tokenizeLine("a*non-bold*a, !*bold*?, '*bold*:, .*bold*; ,*bold*")
      expect(tokens.length).toEqual 16
      expect(tokens[0]).toEqual value: "a*non-bold*a, !", scopes: ["source.asciidoc"]
      expect(tokens[1]).toEqual value: "*", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[2]).toEqual value: "bold", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[3]).toEqual value: "*", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[4]).toEqual value: "?, '", scopes: ["source.asciidoc"]
      expect(tokens[5]).toEqual value: "*", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[6]).toEqual value: "bold", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[7]).toEqual value: "*", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[8]).toEqual value: ":, .", scopes: ["source.asciidoc"]
      expect(tokens[9]).toEqual value: "*", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[10]).toEqual value: "bold", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[11]).toEqual value: "*", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[12]).toEqual value: "; ,", scopes: ["source.asciidoc"]
      expect(tokens[13]).toEqual value: "*", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[14]).toEqual value: "bold", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[15]).toEqual value: "*", scopes: ["source.asciidoc", "markup.bold.asciidoc"]

    it "when variants of unbalanced asterisks around *bold* text", ->
      {tokens} = grammar.tokenizeLine("*bold* **bold* ***bold* ***bold** ***bold*** **bold*** *bold*** *bold**")
      expect(tokens.length).toEqual 26
      expect(tokens[0]).toEqual value: "*", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[1]).toEqual value: "bold", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[2]).toEqual value: "*", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[3]).toEqual value: " ", scopes: ["source.asciidoc"]
      expect(tokens[4]).toEqual value: "**", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[5]).toEqual value: "bold* ", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[6]).toEqual value: "**", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[7]).toEqual value: "*bold* ", scopes: ["source.asciidoc"]
      expect(tokens[8]).toEqual value: "**", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[9]).toEqual value: "*bold", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[10]).toEqual value: "**", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[11]).toEqual value: " ", scopes: ["source.asciidoc"]
      expect(tokens[12]).toEqual value: "**", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[13]).toEqual value: "*bold", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[14]).toEqual value: "**", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[15]).toEqual value: "* ", scopes: ["source.asciidoc"]
      expect(tokens[16]).toEqual value: "**", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[17]).toEqual value: "bold", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[18]).toEqual value: "**", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[19]).toEqual value: "* ", scopes: ["source.asciidoc"]
      expect(tokens[20]).toEqual value: "*", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[21]).toEqual value: "bold", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[22]).toEqual value: "*", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[23]).toEqual value: "**", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[24]).toEqual value: " *bold", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[25]).toEqual value: "**", scopes: ["source.asciidoc", "markup.bold.asciidoc"]

    it "when text is 'this is *bold* text'", ->
      {tokens} = grammar.tokenizeLine("this is *bold* text")
      expect(tokens.length).toEqual 5
      expect(tokens[0]).toEqual value: "this is ", scopes: ["source.asciidoc"]
      expect(tokens[1]).toEqual value: "*", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[2]).toEqual value: "bold", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[3]).toEqual value: "*", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[4]).toEqual value: " text", scopes: ["source.asciidoc"]

    it "when text is '* text*'", ->
      {tokens} = grammar.tokenizeLine("* text*")
      expect(tokens.length).toEqual 3
      expect(tokens[0]).toEqual value: "*", scopes: ["source.asciidoc", "markup.list.asciidoc", "markup.list.bullet.asciidoc"]
      expect(tokens[1]).toEqual value: " ", scopes: ["source.asciidoc", "markup.list.asciidoc"]
      expect(tokens[2]).toEqual value: "text*", scopes: ["source.asciidoc"]

    it "when text is '*bold text*'", ->
      {tokens} = grammar.tokenizeLine("*bold text*")
      expect(tokens.length).toEqual 3
      expect(tokens[0]).toEqual value: "*", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[1]).toEqual value: "bold text", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[2]).toEqual value: "*", scopes: ["source.asciidoc", "markup.bold.asciidoc"]

    it "when text is '*bold*text*'", ->
      {tokens} = grammar.tokenizeLine("*bold*text*")
      expect(tokens.length).toEqual 3
      expect(tokens[0]).toEqual value: "*", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[1]).toEqual value: "bold*text", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[2]).toEqual value: "*", scopes: ["source.asciidoc", "markup.bold.asciidoc"]

    it "when text is '*bold* text *bold* text'", ->
      {tokens} = grammar.tokenizeLine("*bold* text *bold* text")
      expect(tokens.length).toEqual 8
      expect(tokens[0]).toEqual value: "*", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[1]).toEqual value: "bold", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[2]).toEqual value: "*", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[3]).toEqual value: " text ", scopes: ["source.asciidoc"]
      expect(tokens[4]).toEqual value: "*", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[5]).toEqual value: "bold", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[6]).toEqual value: "*", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[7]).toEqual value: " text", scopes: ["source.asciidoc"]

    it "when text is '* *bold* text' (list context)", ->
      {tokens} = grammar.tokenizeLine("* *bold* text")
      expect(tokens.length).toEqual 6
      expect(tokens[0]).toEqual value: "*", scopes: ["source.asciidoc", "markup.list.asciidoc", "markup.list.bullet.asciidoc"]
      expect(tokens[1]).toEqual value: " ", scopes: ["source.asciidoc", "markup.list.asciidoc"]
      expect(tokens[2]).toEqual value: "*", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[3]).toEqual value: "bold", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[4]).toEqual value: "*", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[5]).toEqual value: " text", scopes: ["source.asciidoc"]

    it "when text is '* *bold*' (list context)", ->
      {tokens} = grammar.tokenizeLine("* *bold*")
      expect(tokens.length).toEqual 5
      expect(tokens[0]).toEqual value: "*", scopes: ["source.asciidoc", "markup.list.asciidoc", "markup.list.bullet.asciidoc"]
      expect(tokens[1]).toEqual value: " ", scopes: ["source.asciidoc", "markup.list.asciidoc"]
      expect(tokens[2]).toEqual value: "*", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[3]).toEqual value: "bold", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[4]).toEqual value: "*", scopes: ["source.asciidoc", "markup.bold.asciidoc"]

    it "when having a [role] set on constrained *bold* text", ->
      {tokens} = grammar.tokenizeLine("[role]*bold*")
      expect(tokens.length).toEqual 4
      expect(tokens[0]).toEqual value: "[role]", scopes: ["source.asciidoc", "markup.bold.asciidoc", "support.constant.asciidoc"]
      expect(tokens[1]).toEqual value: "*", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[2]).toEqual value: "bold", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[3]).toEqual value: "*", scopes: ["source.asciidoc", "markup.bold.asciidoc"]

    it "when having [role1 role2] set on constrained *bold* text", ->
      {tokens} = grammar.tokenizeLine("[role1 role2]*bold*")
      expect(tokens.length).toEqual 4
      expect(tokens[0]).toEqual value: "[role1 role2]", scopes: ["source.asciidoc", "markup.bold.asciidoc", "support.constant.asciidoc"]
      expect(tokens[1]).toEqual value: "*", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[2]).toEqual value: "bold", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[3]).toEqual value: "*", scopes: ["source.asciidoc", "markup.bold.asciidoc"]

    it "when having a [role] set on unconstrained *bold* text", ->
      {tokens} = grammar.tokenizeLine("[role]**bold**")
      expect(tokens.length).toEqual 4
      expect(tokens[0]).toEqual value: "[role]", scopes: ["source.asciidoc", "markup.bold.asciidoc", "support.constant.asciidoc"]
      expect(tokens[1]).toEqual value: "**", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[2]).toEqual value: "bold", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[3]).toEqual value: "**", scopes: ["source.asciidoc", "markup.bold.asciidoc"]

    it "when having [role1 role2] set on unconstrained **bold** text", ->
      {tokens} = grammar.tokenizeLine("[role1 role2]**bold**")
      expect(tokens.length).toEqual 4
      expect(tokens[0]).toEqual value: "[role1 role2]", scopes: ["source.asciidoc", "markup.bold.asciidoc", "support.constant.asciidoc"]
      expect(tokens[1]).toEqual value: "**", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[2]).toEqual value: "bold", scopes: ["source.asciidoc", "markup.bold.asciidoc"]
      expect(tokens[3]).toEqual value: "**", scopes: ["source.asciidoc", "markup.bold.asciidoc"]