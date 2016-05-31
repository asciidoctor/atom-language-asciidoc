describe 'Attributes', ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage 'language-asciidoc'

    runs ->
      grammar = atom.grammars.grammarForScopeName 'source.asciidoc'

  it 'parses the grammar', ->
    expect(grammar).toBeDefined()
    expect(grammar.scopeName).toBe 'source.asciidoc'

  describe 'Should tokenizes when', ->

    describe 'single-line', ->

      it 'simple attributes not following with text', ->
        {tokens} = grammar.tokenizeLine ':sectanchors:'
        expect(tokens).toHaveLength 3
        expect(tokens[0]).toEqualJson value: ':', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'punctuation.separator.asciidoc']
        expect(tokens[1]).toEqualJson value: 'sectanchors', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'support.constant.attribute-name.asciidoc']
        expect(tokens[2]).toEqualJson value: ':', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'punctuation.separator.asciidoc']

      it 'following with text', ->
        {tokens} = grammar.tokenizeLine ':icons: font'
        expect(tokens).toHaveLength 4
        expect(tokens[0]).toEqualJson value: ':', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'punctuation.separator.asciidoc']
        expect(tokens[1]).toEqualJson value: 'icons', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'support.constant.attribute-name.asciidoc']
        expect(tokens[2]).toEqualJson value: ':', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'punctuation.separator.asciidoc']
        expect(tokens[3]).toEqualJson value: ' font', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'string.unquoted.attribute-value.asciidoc']

      it 'contains negate', ->
        {tokens} = grammar.tokenizeLine ':!compat-mode:'
        expect(tokens).toHaveLength 3
        expect(tokens[0]).toEqualJson value: ':', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'punctuation.separator.asciidoc']
        expect(tokens[1]).toEqualJson value: '!compat-mode', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'support.constant.attribute-name.asciidoc']
        expect(tokens[2]).toEqualJson value: ':', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'punctuation.separator.asciidoc']

      it 'contains an URL', ->
        {tokens} = grammar.tokenizeLine ':homepage: http://asciidoctor.org'
        expect(tokens).toHaveLength 5
        expect(tokens[0]).toEqualJson value: ':', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'punctuation.separator.asciidoc']
        expect(tokens[1]).toEqualJson value: 'homepage', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'support.constant.attribute-name.asciidoc']
        expect(tokens[2]).toEqualJson value: ':', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'punctuation.separator.asciidoc']
        expect(tokens[3]).toEqualJson value: ' ', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'string.unquoted.attribute-value.asciidoc', 'markup.other.url.asciidoc']
        expect(tokens[4]).toEqualJson value: 'http://asciidoctor.org', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'string.unquoted.attribute-value.asciidoc', 'markup.other.url.asciidoc', 'markup.link.asciidoc']

    describe 'multi-lines', ->

      it 'contains link', ->
        tokens = grammar.tokenizeLines '''
          :description: foo bar +
            foo link:http://asciidoctor.org[AsciiDoctor] bar +
            text and text
          '''
        expect(tokens).toHaveLength 3
        expect(tokens[0]).toHaveLength 6
        expect(tokens[0][0]).toEqualJson value: ':', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'punctuation.separator.attribute-entry.asciidoc']
        expect(tokens[0][1]).toEqualJson value: 'description', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'support.constant.attribute-name.asciidoc']
        expect(tokens[0][2]).toEqualJson value: ':', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'punctuation.separator.attribute-entry.asciidoc']
        expect(tokens[0][3]).toEqualJson value: ' foo bar', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'string.unquoted.attribute-value.asciidoc']
        expect(tokens[0][4]).toEqualJson value: ' ', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'string.unquoted.attribute-value.asciidoc']
        expect(tokens[0][5]).toEqualJson value: '+', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'string.unquoted.attribute-value.asciidoc', 'variable.line-break.asciidoc']
        expect(tokens[1]).toHaveLength 10
        expect(tokens[1][0]).toEqualJson value: '  foo ', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'string.unquoted.attribute-value.asciidoc']
        expect(tokens[1][1]).toEqualJson value: 'link', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'string.unquoted.attribute-value.asciidoc', 'markup.other.url.asciidoc', 'entity.name.function.asciidoc']
        expect(tokens[1][2]).toEqualJson value: ':', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'string.unquoted.attribute-value.asciidoc', 'markup.other.url.asciidoc']
        expect(tokens[1][3]).toEqualJson value: 'http://asciidoctor.org', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'string.unquoted.attribute-value.asciidoc', 'markup.other.url.asciidoc', 'markup.link.asciidoc']
        expect(tokens[1][4]).toEqualJson value: '[', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'string.unquoted.attribute-value.asciidoc', 'markup.other.url.asciidoc']
        expect(tokens[1][5]).toEqualJson value: 'AsciiDoctor', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'string.unquoted.attribute-value.asciidoc', 'markup.other.url.asciidoc', 'string.unquoted.asciidoc']
        expect(tokens[1][6]).toEqualJson value: ']', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'string.unquoted.attribute-value.asciidoc', 'markup.other.url.asciidoc']
        expect(tokens[1][7]).toEqualJson value: ' bar', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'string.unquoted.attribute-value.asciidoc']
        expect(tokens[1][8]).toEqualJson value: ' ', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'string.unquoted.attribute-value.asciidoc']
        expect(tokens[1][9]).toEqualJson value: '+', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'string.unquoted.attribute-value.asciidoc', 'variable.line-break.asciidoc']
        expect(tokens[2]).toHaveLength 1
        expect(tokens[2][0]).toEqualJson value: '  text and text', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'string.unquoted.attribute-value.asciidoc']

      it 'contains line-break backslash', ->
        tokens = grammar.tokenizeLines '''
          :description: foo bar \\
            foo link:http://asciidoctor.org[AsciiDoctor] bar \\
            text and text
          '''
        expect(tokens).toHaveLength 3
        expect(tokens[0]).toHaveLength 6
        expect(tokens[0][0]).toEqualJson value: ':', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'punctuation.separator.attribute-entry.asciidoc']
        expect(tokens[0][1]).toEqualJson value: 'description', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'support.constant.attribute-name.asciidoc']
        expect(tokens[0][2]).toEqualJson value: ':', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'punctuation.separator.attribute-entry.asciidoc']
        expect(tokens[0][3]).toEqualJson value: ' foo bar', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'string.unquoted.attribute-value.asciidoc']
        expect(tokens[0][4]).toEqualJson value: ' ', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'string.unquoted.attribute-value.asciidoc']
        expect(tokens[0][5]).toEqualJson value: '\\', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'string.unquoted.attribute-value.asciidoc', 'variable.line-break.asciidoc']
        expect(tokens[1]).toHaveLength 10
        expect(tokens[1][0]).toEqualJson value: '  foo ', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'string.unquoted.attribute-value.asciidoc']
        expect(tokens[1][1]).toEqualJson value: 'link', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'string.unquoted.attribute-value.asciidoc', 'markup.other.url.asciidoc', 'entity.name.function.asciidoc']
        expect(tokens[1][2]).toEqualJson value: ':', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'string.unquoted.attribute-value.asciidoc', 'markup.other.url.asciidoc']
        expect(tokens[1][3]).toEqualJson value: 'http://asciidoctor.org', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'string.unquoted.attribute-value.asciidoc', 'markup.other.url.asciidoc', 'markup.link.asciidoc']
        expect(tokens[1][4]).toEqualJson value: '[', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'string.unquoted.attribute-value.asciidoc', 'markup.other.url.asciidoc']
        expect(tokens[1][5]).toEqualJson value: 'AsciiDoctor', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'string.unquoted.attribute-value.asciidoc', 'markup.other.url.asciidoc', 'string.unquoted.asciidoc']
        expect(tokens[1][6]).toEqualJson value: ']', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'string.unquoted.attribute-value.asciidoc', 'markup.other.url.asciidoc']
        expect(tokens[1][7]).toEqualJson value: ' bar', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'string.unquoted.attribute-value.asciidoc']
        expect(tokens[1][8]).toEqualJson value: ' ', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'string.unquoted.attribute-value.asciidoc']
        expect(tokens[1][9]).toEqualJson value: '\\', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'string.unquoted.attribute-value.asciidoc', 'variable.line-break.asciidoc']
        expect(tokens[2]).toHaveLength 1
        expect(tokens[2][0]).toEqualJson value: '  text and text', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'string.unquoted.attribute-value.asciidoc']

      it 'contains hard-break backslash', ->
        tokens = grammar.tokenizeLines '''
          :description: foo bar + \\
            foo link:http://asciidoctor.org[AsciiDoctor] bar + \\
            text and text
          '''
        expect(tokens).toHaveLength 3
        expect(tokens[0]).toHaveLength 6
        expect(tokens[0][0]).toEqualJson value: ':', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'punctuation.separator.attribute-entry.asciidoc']
        expect(tokens[0][1]).toEqualJson value: 'description', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'support.constant.attribute-name.asciidoc']
        expect(tokens[0][2]).toEqualJson value: ':', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'punctuation.separator.attribute-entry.asciidoc']
        expect(tokens[0][3]).toEqualJson value: ' foo bar', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'string.unquoted.attribute-value.asciidoc']
        expect(tokens[0][4]).toEqualJson value: ' ', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'string.unquoted.attribute-value.asciidoc']
        expect(tokens[0][5]).toEqualJson value: '+ \\', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'string.unquoted.attribute-value.asciidoc', 'constant.other.symbol.hard-break.asciidoc']
        expect(tokens[1]).toHaveLength 10
        expect(tokens[1][0]).toEqualJson value: '  foo ', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'string.unquoted.attribute-value.asciidoc']
        expect(tokens[1][1]).toEqualJson value: 'link', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'string.unquoted.attribute-value.asciidoc', 'markup.other.url.asciidoc', 'entity.name.function.asciidoc']
        expect(tokens[1][2]).toEqualJson value: ':', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'string.unquoted.attribute-value.asciidoc', 'markup.other.url.asciidoc']
        expect(tokens[1][3]).toEqualJson value: 'http://asciidoctor.org', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'string.unquoted.attribute-value.asciidoc', 'markup.other.url.asciidoc', 'markup.link.asciidoc']
        expect(tokens[1][4]).toEqualJson value: '[', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'string.unquoted.attribute-value.asciidoc', 'markup.other.url.asciidoc']
        expect(tokens[1][5]).toEqualJson value: 'AsciiDoctor', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'string.unquoted.attribute-value.asciidoc', 'markup.other.url.asciidoc', 'string.unquoted.asciidoc']
        expect(tokens[1][6]).toEqualJson value: ']', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'string.unquoted.attribute-value.asciidoc', 'markup.other.url.asciidoc']
        expect(tokens[1][7]).toEqualJson value: ' bar', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'string.unquoted.attribute-value.asciidoc']
        expect(tokens[1][8]).toEqualJson value: ' ', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'string.unquoted.attribute-value.asciidoc']
        expect(tokens[1][9]).toEqualJson value: '+ \\', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'string.unquoted.attribute-value.asciidoc', 'constant.other.symbol.hard-break.asciidoc']
        expect(tokens[2]).toHaveLength 1
        expect(tokens[2][0]).toEqualJson value: '  text and text', scopes: ['source.asciidoc', 'meta.definition.attribute-entry.asciidoc', 'string.unquoted.attribute-value.asciidoc']
