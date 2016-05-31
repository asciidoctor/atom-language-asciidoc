describe 'mark text', ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage 'language-asciidoc'

    runs ->
      grammar = atom.grammars.grammarForScopeName 'source.asciidoc'

  describe 'Should tokenizes constrained mark text', ->

    it 'when constrained mark text', ->
      {tokens} = grammar.tokenizeLine 'this is #mark# text'
      expect(tokens).toHaveLength 5
      expect(tokens[0]).toEqualJson value: 'this is ', scopes: ['source.asciidoc']
      expect(tokens[1]).toEqualJson value: '#', scopes: ['source.asciidoc', 'markup.mark.constrained.asciidoc', 'markup.highlight.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[2]).toEqualJson value: 'mark', scopes: ['source.asciidoc', 'markup.mark.constrained.asciidoc', 'markup.highlight.asciidoc']
      expect(tokens[3]).toEqualJson value: '#', scopes: ['source.asciidoc', 'markup.mark.constrained.asciidoc', 'markup.highlight.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[4]).toEqualJson value: ' text', scopes: ['source.asciidoc']

    it 'when constrained mark at the beginning of the line', ->
      {tokens} = grammar.tokenizeLine '#mark text# from the start.'
      expect(tokens).toHaveLength 4
      expect(tokens[0]).toEqualJson value: '#', scopes: ['source.asciidoc', 'markup.mark.constrained.asciidoc', 'markup.highlight.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[1]).toEqualJson value: 'mark text', scopes: ['source.asciidoc', 'markup.mark.constrained.asciidoc', 'markup.highlight.asciidoc']
      expect(tokens[2]).toEqualJson value: '#', scopes: ['source.asciidoc', 'markup.mark.constrained.asciidoc', 'markup.highlight.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[3]).toEqualJson value: ' from the start.', scopes: ['source.asciidoc']

    it 'when constrained mark is escaped', ->
      {tokens} = grammar.tokenizeLine '\\#mark text#'
      expect(tokens).toHaveLength 1
      expect(tokens[0]).toEqualJson value: '\\#mark text#', scopes: ['source.asciidoc']

    it 'when constrained mark in a *bulleted list', ->
      {tokens} = grammar.tokenizeLine '* #mark text# followed by normal text'
      expect(tokens).toHaveLength 6
      expect(tokens[0]).toEqualJson value: '*', scopes: ['source.asciidoc', 'markup.list.asciidoc', 'markup.list.bullet.asciidoc']
      expect(tokens[1]).toEqualJson value: ' ', scopes: ['source.asciidoc']
      expect(tokens[2]).toEqualJson value: '#', scopes: ['source.asciidoc', 'markup.mark.constrained.asciidoc', 'markup.highlight.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[3]).toEqualJson value: 'mark text', scopes: ['source.asciidoc', 'markup.mark.constrained.asciidoc', 'markup.highlight.asciidoc']
      expect(tokens[4]).toEqualJson value: '#', scopes: ['source.asciidoc', 'markup.mark.constrained.asciidoc', 'markup.highlight.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[5]).toEqualJson value: ' followed by normal text', scopes: ['source.asciidoc']

    it 'when constrained mark text within special characters', ->
      {tokens} = grammar.tokenizeLine 'a#non-mark#a, !#mark#?, \'#mark#:, .#mark#; ,#mark#'
      expect(tokens).toHaveLength 16
      expect(tokens[0]).toEqualJson value: 'a#non-mark#a, !', scopes: ['source.asciidoc']
      expect(tokens[1]).toEqualJson value: '#', scopes: ['source.asciidoc', 'markup.mark.constrained.asciidoc', 'markup.highlight.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[2]).toEqualJson value: 'mark', scopes: ['source.asciidoc', 'markup.mark.constrained.asciidoc', 'markup.highlight.asciidoc']
      expect(tokens[3]).toEqualJson value: '#', scopes: ['source.asciidoc', 'markup.mark.constrained.asciidoc', 'markup.highlight.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[4]).toEqualJson value: '?, \'', scopes: ['source.asciidoc']
      expect(tokens[5]).toEqualJson value: '#', scopes: ['source.asciidoc', 'markup.mark.constrained.asciidoc', 'markup.highlight.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[6]).toEqualJson value: 'mark', scopes: ['source.asciidoc', 'markup.mark.constrained.asciidoc', 'markup.highlight.asciidoc']
      expect(tokens[7]).toEqualJson value: '#', scopes: ['source.asciidoc', 'markup.mark.constrained.asciidoc', 'markup.highlight.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[8]).toEqualJson value: ':, .', scopes: ['source.asciidoc']
      expect(tokens[9]).toEqualJson value: '#', scopes: ['source.asciidoc', 'markup.mark.constrained.asciidoc', 'markup.highlight.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[10]).toEqualJson value: 'mark', scopes: ['source.asciidoc', 'markup.mark.constrained.asciidoc', 'markup.highlight.asciidoc']
      expect(tokens[11]).toEqualJson value: '#', scopes: ['source.asciidoc', 'markup.mark.constrained.asciidoc', 'markup.highlight.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[12]).toEqualJson value: '; ,', scopes: ['source.asciidoc']
      expect(tokens[13]).toEqualJson value: '#', scopes: ['source.asciidoc', 'markup.mark.constrained.asciidoc', 'markup.highlight.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[14]).toEqualJson value: 'mark', scopes: ['source.asciidoc', 'markup.mark.constrained.asciidoc', 'markup.highlight.asciidoc']
      expect(tokens[15]).toEqualJson value: '#', scopes: ['source.asciidoc', 'markup.mark.constrained.asciidoc', 'markup.highlight.asciidoc', 'punctuation.definition.asciidoc']

    it 'when text is "this is \\#mark\\# text"', ->
      {tokens} = grammar.tokenizeLine 'this is #mark# text'
      expect(tokens).toHaveLength 5
      expect(tokens[0]).toEqualJson value: 'this is ', scopes: ['source.asciidoc']
      expect(tokens[1]).toEqualJson value: '#', scopes: ['source.asciidoc', 'markup.mark.constrained.asciidoc', 'markup.highlight.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[2]).toEqualJson value: 'mark', scopes: ['source.asciidoc', 'markup.mark.constrained.asciidoc', 'markup.highlight.asciidoc']
      expect(tokens[3]).toEqualJson value: '#', scopes: ['source.asciidoc', 'markup.mark.constrained.asciidoc', 'markup.highlight.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[4]).toEqualJson value: ' text', scopes: ['source.asciidoc']

    it 'when text is "* text\\#"', ->
      {tokens} = grammar.tokenizeLine '* text#'
      expect(tokens).toHaveLength 2
      expect(tokens[0]).toEqualJson value: '*', scopes: ['source.asciidoc', 'markup.list.asciidoc', 'markup.list.bullet.asciidoc']
      expect(tokens[1]).toEqualJson value: ' text#', scopes: ['source.asciidoc']

    it 'when text is "\\#mark text\\#"', ->
      {tokens} = grammar.tokenizeLine '#mark text#'
      expect(tokens).toHaveLength 3
      expect(tokens[0]).toEqualJson value: '#', scopes: ['source.asciidoc', 'markup.mark.constrained.asciidoc', 'markup.highlight.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[1]).toEqualJson value: 'mark text', scopes: ['source.asciidoc', 'markup.mark.constrained.asciidoc', 'markup.highlight.asciidoc']
      expect(tokens[2]).toEqualJson value: '#', scopes: ['source.asciidoc', 'markup.mark.constrained.asciidoc', 'markup.highlight.asciidoc', 'punctuation.definition.asciidoc']

    it 'when text is "\\#mark\\#text\\#"', ->
      {tokens} = grammar.tokenizeLine '#mark#text#'
      expect(tokens).toHaveLength 3
      expect(tokens[0]).toEqualJson value: '#', scopes: ['source.asciidoc', 'markup.mark.constrained.asciidoc', 'markup.highlight.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[1]).toEqualJson value: 'mark#text', scopes: ['source.asciidoc', 'markup.mark.constrained.asciidoc', 'markup.highlight.asciidoc']
      expect(tokens[2]).toEqualJson value: '#', scopes: ['source.asciidoc', 'markup.mark.constrained.asciidoc', 'markup.highlight.asciidoc', 'punctuation.definition.asciidoc']

    it 'when text is "\\#mark\\# text \\#mark\\# text"', ->
      {tokens} = grammar.tokenizeLine '#mark# text #mark# text'
      expect(tokens).toHaveLength 8
      expect(tokens[0]).toEqualJson value: '#', scopes: ['source.asciidoc', 'markup.mark.constrained.asciidoc', 'markup.highlight.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[1]).toEqualJson value: 'mark', scopes: ['source.asciidoc', 'markup.mark.constrained.asciidoc', 'markup.highlight.asciidoc']
      expect(tokens[2]).toEqualJson value: '#', scopes: ['source.asciidoc', 'markup.mark.constrained.asciidoc', 'markup.highlight.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[3]).toEqualJson value: ' text ', scopes: ['source.asciidoc']
      expect(tokens[4]).toEqualJson value: '#', scopes: ['source.asciidoc', 'markup.mark.constrained.asciidoc', 'markup.highlight.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[5]).toEqualJson value: 'mark', scopes: ['source.asciidoc', 'markup.mark.constrained.asciidoc', 'markup.highlight.asciidoc']
      expect(tokens[6]).toEqualJson value: '#', scopes: ['source.asciidoc', 'markup.mark.constrained.asciidoc', 'markup.highlight.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[7]).toEqualJson value: ' text', scopes: ['source.asciidoc']

    it 'when text is "* \\#mark\\# text" (list context)', ->
      {tokens} = grammar.tokenizeLine '* #mark# text'
      expect(tokens).toHaveLength 6
      expect(tokens[0]).toEqualJson value: '*', scopes: ['source.asciidoc', 'markup.list.asciidoc', 'markup.list.bullet.asciidoc']
      expect(tokens[1]).toEqualJson value: ' ', scopes: ['source.asciidoc']
      expect(tokens[2]).toEqualJson value: '#', scopes: ['source.asciidoc', 'markup.mark.constrained.asciidoc', 'markup.highlight.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[3]).toEqualJson value: 'mark', scopes: ['source.asciidoc', 'markup.mark.constrained.asciidoc', 'markup.highlight.asciidoc']
      expect(tokens[4]).toEqualJson value: '#', scopes: ['source.asciidoc', 'markup.mark.constrained.asciidoc', 'markup.highlight.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[5]).toEqualJson value: ' text', scopes: ['source.asciidoc']

    it 'when text is "* \\#mark\\#" (list context)', ->
      {tokens} = grammar.tokenizeLine '* #mark#'
      expect(tokens).toHaveLength 5
      expect(tokens[0]).toEqualJson value: '*', scopes: ['source.asciidoc', 'markup.list.asciidoc', 'markup.list.bullet.asciidoc']
      expect(tokens[1]).toEqualJson value: ' ', scopes: ['source.asciidoc']
      expect(tokens[2]).toEqualJson value: '#', scopes: ['source.asciidoc', 'markup.mark.constrained.asciidoc', 'markup.highlight.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[3]).toEqualJson value: 'mark', scopes: ['source.asciidoc', 'markup.mark.constrained.asciidoc', 'markup.highlight.asciidoc']
      expect(tokens[4]).toEqualJson value: '#', scopes: ['source.asciidoc', 'markup.mark.constrained.asciidoc', 'markup.highlight.asciidoc', 'punctuation.definition.asciidoc']

    it 'when having a [role] set on constrained mark text', ->
      {tokens} = grammar.tokenizeLine '[role]#mark#'
      expect(tokens).toHaveLength 4
      expect(tokens[0]).toEqualJson value: '[role]', scopes: ['source.asciidoc', 'markup.mark.constrained.asciidoc', 'markup.meta.attribute-list.asciidoc']
      expect(tokens[1]).toEqualJson value: '#', scopes: ['source.asciidoc', 'markup.mark.constrained.asciidoc', 'markup.mark.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[2]).toEqualJson value: 'mark', scopes: ['source.asciidoc', 'markup.mark.constrained.asciidoc', 'markup.mark.asciidoc']
      expect(tokens[3]).toEqualJson value: '#', scopes: ['source.asciidoc', 'markup.mark.constrained.asciidoc', 'markup.mark.asciidoc', 'punctuation.definition.asciidoc']

    it 'when having [role1 role2] set on constrained mark text', ->
      {tokens} = grammar.tokenizeLine '[role1 role2]#mark#'
      expect(tokens).toHaveLength 4
      expect(tokens[0]).toEqualJson value: '[role1 role2]', scopes: ['source.asciidoc', 'markup.mark.constrained.asciidoc', 'markup.meta.attribute-list.asciidoc']
      expect(tokens[1]).toEqualJson value: '#', scopes: ['source.asciidoc', 'markup.mark.constrained.asciidoc', 'markup.mark.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[2]).toEqualJson value: 'mark', scopes: ['source.asciidoc', 'markup.mark.constrained.asciidoc', 'markup.mark.asciidoc']
      expect(tokens[3]).toEqualJson value: '#', scopes: ['source.asciidoc', 'markup.mark.constrained.asciidoc', 'markup.mark.asciidoc', 'punctuation.definition.asciidoc']

  describe 'Should tokenizes unconstrained math text', ->

    it 'when unconstrained mark text', ->
      {tokens} = grammar.tokenizeLine 'this is##mark##text'
      expect(tokens[0]).toEqualJson value: 'this is', scopes: ['source.asciidoc']
      expect(tokens[1]).toEqualJson value: '##', scopes: ['source.asciidoc', 'markup.mark.unconstrained.asciidoc', 'markup.highlight.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[2]).toEqualJson value: 'mark', scopes: ['source.asciidoc', 'markup.mark.unconstrained.asciidoc', 'markup.highlight.asciidoc']
      expect(tokens[3]).toEqualJson value: '##', scopes: ['source.asciidoc', 'markup.mark.unconstrained.asciidoc', 'markup.highlight.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[4]).toEqualJson value: 'text', scopes: ['source.asciidoc']

    it 'when unconstrained mark text with asterisks', ->
      {tokens} = grammar.tokenizeLine 'this is##mark#text##'
      expect(tokens[0]).toEqualJson value: 'this is', scopes: ['source.asciidoc']
      expect(tokens[1]).toEqualJson value: '##', scopes: ['source.asciidoc', 'markup.mark.unconstrained.asciidoc', 'markup.highlight.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[2]).toEqualJson value: 'mark#text', scopes: ['source.asciidoc', 'markup.mark.unconstrained.asciidoc', 'markup.highlight.asciidoc']
      expect(tokens[3]).toEqualJson value: '##', scopes: ['source.asciidoc', 'markup.mark.unconstrained.asciidoc', 'markup.highlight.asciidoc', 'punctuation.definition.asciidoc']

    it 'when unconstrained mark is double escaped', ->
      {tokens} = grammar.tokenizeLine '\\\\##mark text##'
      expect(tokens).toHaveLength 1
      expect(tokens[0]).toEqualJson value: '\\\\##mark text##', scopes: ['source.asciidoc']

    it 'when having a [role] set on unconstrained mark text', ->
      {tokens} = grammar.tokenizeLine '[role]##mark##'
      expect(tokens).toHaveLength 4
      expect(tokens[0]).toEqualJson value: '[role]', scopes: ['source.asciidoc', 'markup.mark.unconstrained.asciidoc', 'markup.meta.attribute-list.asciidoc']
      expect(tokens[1]).toEqualJson value: '##', scopes: ['source.asciidoc', 'markup.mark.unconstrained.asciidoc', 'markup.mark.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[2]).toEqualJson value: 'mark', scopes: ['source.asciidoc', 'markup.mark.unconstrained.asciidoc', 'markup.mark.asciidoc']
      expect(tokens[3]).toEqualJson value: '##', scopes: ['source.asciidoc', 'markup.mark.unconstrained.asciidoc', 'markup.mark.asciidoc', 'punctuation.definition.asciidoc']

    it 'when having [role1 role2] set on unconstrained mark text', ->
      {tokens} = grammar.tokenizeLine '[role1 role2]##mark##'
      expect(tokens).toHaveLength 4
      expect(tokens[0]).toEqualJson value: '[role1 role2]', scopes: ['source.asciidoc', 'markup.mark.unconstrained.asciidoc', 'markup.meta.attribute-list.asciidoc']
      expect(tokens[1]).toEqualJson value: '##', scopes: ['source.asciidoc', 'markup.mark.unconstrained.asciidoc', 'markup.mark.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[2]).toEqualJson value: 'mark', scopes: ['source.asciidoc', 'markup.mark.unconstrained.asciidoc', 'markup.mark.asciidoc']
      expect(tokens[3]).toEqualJson value: '##', scopes: ['source.asciidoc', 'markup.mark.unconstrained.asciidoc', 'markup.mark.asciidoc', 'punctuation.definition.asciidoc']
