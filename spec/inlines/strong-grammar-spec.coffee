describe '*strong* text', ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage('language-asciidoc')

    runs ->
      grammar = atom.grammars.grammarForScopeName('source.asciidoc')

  it 'parses the grammar', ->
    expect(grammar).toBeDefined()
    expect(grammar.scopeName).toBe 'source.asciidoc'

  describe 'Should tokenizes constrained *strong* text', ->

    it 'when constrained *strong* text', ->
      {tokens} = grammar.tokenizeLine 'this is *strong* text'
      expect(tokens).toHaveLength 5
      expect(tokens[0]).toEqualJson value: 'this is ', scopes: ['source.asciidoc']
      expect(tokens[1]).toEqualJson value: '*', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[2]).toEqualJson value: 'strong', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc']
      expect(tokens[3]).toEqualJson value: '*', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[4]).toEqualJson value: ' text', scopes: ['source.asciidoc']

    it 'when constrained *strong* at the beginning of the line', ->
      {tokens} = grammar.tokenizeLine '*strong text* from the start.'
      expect(tokens).toHaveLength 4
      expect(tokens[0]).toEqualJson value: '*', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[1]).toEqualJson value: 'strong text', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc']
      expect(tokens[2]).toEqualJson value: '*', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[3]).toEqualJson value: ' from the start.', scopes: ['source.asciidoc']

    it 'when constrained *strong* is escaped', ->
      {tokens} = grammar.tokenizeLine '\\*strong text*'
      expect(tokens).toHaveLength 1
      expect(tokens[0]).toEqualJson value: '\\*strong text*', scopes: ['source.asciidoc']

    it 'when constrained *strong* in a * bulleted list', ->
      {tokens} = grammar.tokenizeLine '* *strong text* followed by normal text'
      expect(tokens).toHaveLength 6
      expect(tokens[0]).toEqualJson value: '*', scopes: ['source.asciidoc', 'markup.list.asciidoc', 'markup.list.bullet.asciidoc']
      expect(tokens[1]).toEqualJson value: ' ', scopes: ['source.asciidoc']
      expect(tokens[2]).toEqualJson value: '*', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[3]).toEqualJson value: 'strong text', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc']
      expect(tokens[4]).toEqualJson value: '*', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[5]).toEqualJson value: ' followed by normal text', scopes: ['source.asciidoc']

    it 'when constrained *strong* text within special characters', ->
      {tokens} = grammar.tokenizeLine 'a*non-strong*a, !*strong*?, \'*strong*:, .*strong*; ,*strong*'
      expect(tokens).toHaveLength 16
      expect(tokens[0]).toEqualJson value: 'a*non-strong*a, !', scopes: ['source.asciidoc']
      expect(tokens[1]).toEqualJson value: '*', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[2]).toEqualJson value: 'strong', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc']
      expect(tokens[3]).toEqualJson value: '*', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[4]).toEqualJson value: '?, \'', scopes: ['source.asciidoc']
      expect(tokens[5]).toEqualJson value: '*', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[6]).toEqualJson value: 'strong', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc']
      expect(tokens[7]).toEqualJson value: '*', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[8]).toEqualJson value: ':, .', scopes: ['source.asciidoc']
      expect(tokens[9]).toEqualJson value: '*', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[10]).toEqualJson value: 'strong', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc']
      expect(tokens[11]).toEqualJson value: '*', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[12]).toEqualJson value: '; ,', scopes: ['source.asciidoc']
      expect(tokens[13]).toEqualJson value: '*', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[14]).toEqualJson value: 'strong', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc']
      expect(tokens[15]).toEqualJson value: '*', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc', 'punctuation.definition.asciidoc']

    it 'when text is "this is *strong* text"', ->
      {tokens} = grammar.tokenizeLine 'this is *strong* text'
      expect(tokens).toHaveLength 5
      expect(tokens[0]).toEqualJson value: 'this is ', scopes: ['source.asciidoc']
      expect(tokens[1]).toEqualJson value: '*', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[2]).toEqualJson value: 'strong', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc']
      expect(tokens[3]).toEqualJson value: '*', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[4]).toEqualJson value: ' text', scopes: ['source.asciidoc']

    it 'when text is "* text*"', ->
      {tokens} = grammar.tokenizeLine '* text*'
      expect(tokens).toHaveLength 2
      expect(tokens[0]).toEqualJson value: '*', scopes: ['source.asciidoc', 'markup.list.asciidoc', 'markup.list.bullet.asciidoc']
      expect(tokens[1]).toEqualJson value: ' text*', scopes: ['source.asciidoc']

    it 'when text is "*strong text*"', ->
      {tokens} = grammar.tokenizeLine '*strong text*'
      expect(tokens).toHaveLength 3
      expect(tokens[0]).toEqualJson value: '*', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[1]).toEqualJson value: 'strong text', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc']
      expect(tokens[2]).toEqualJson value: '*', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc', 'punctuation.definition.asciidoc']

    it 'when text is "*strong*text*"', ->
      {tokens} = grammar.tokenizeLine '*strong*text*'
      expect(tokens).toHaveLength 3
      expect(tokens[0]).toEqualJson value: '*', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[1]).toEqualJson value: 'strong*text', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc']
      expect(tokens[2]).toEqualJson value: '*', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc', 'punctuation.definition.asciidoc']

    it 'when text is "*strong* text *strong* text"', ->
      {tokens} = grammar.tokenizeLine '*strong* text *strong* text'
      expect(tokens).toHaveLength 8
      expect(tokens[0]).toEqualJson value: '*', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[1]).toEqualJson value: 'strong', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc']
      expect(tokens[2]).toEqualJson value: '*', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[3]).toEqualJson value: ' text ', scopes: ['source.asciidoc']
      expect(tokens[4]).toEqualJson value: '*', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[5]).toEqualJson value: 'strong', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc']
      expect(tokens[6]).toEqualJson value: '*', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[7]).toEqualJson value: ' text', scopes: ['source.asciidoc']

    it 'when text is "* *strong* text" (list context)', ->
      {tokens} = grammar.tokenizeLine '* *strong* text'
      expect(tokens).toHaveLength 6
      expect(tokens[0]).toEqualJson value: '*', scopes: ['source.asciidoc', 'markup.list.asciidoc', 'markup.list.bullet.asciidoc']
      expect(tokens[1]).toEqualJson value: ' ', scopes: ['source.asciidoc']
      expect(tokens[2]).toEqualJson value: '*', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[3]).toEqualJson value: 'strong', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc']
      expect(tokens[4]).toEqualJson value: '*', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[5]).toEqualJson value: ' text', scopes: ['source.asciidoc']

    it 'when text is "* *strong*" (list context)', ->
      {tokens} = grammar.tokenizeLine '* *strong*'
      expect(tokens).toHaveLength 5
      expect(tokens[0]).toEqualJson value: '*', scopes: ['source.asciidoc', 'markup.list.asciidoc', 'markup.list.bullet.asciidoc']
      expect(tokens[1]).toEqualJson value: ' ', scopes: ['source.asciidoc']
      expect(tokens[2]).toEqualJson value: '*', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[3]).toEqualJson value: 'strong', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc']
      expect(tokens[4]).toEqualJson value: '*', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc', 'punctuation.definition.asciidoc']

    it 'when having a [role] set on constrained *strong* text', ->
      {tokens} = grammar.tokenizeLine '[role]*strong*'
      expect(tokens).toHaveLength 4
      expect(tokens[0]).toEqualJson value: '[role]', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.meta.attribute-list.asciidoc']
      expect(tokens[1]).toEqualJson value: '*', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[2]).toEqualJson value: 'strong', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc']
      expect(tokens[3]).toEqualJson value: '*', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc', 'punctuation.definition.asciidoc']

    it 'when having [role1 role2] set on constrained *strong* text', ->
      {tokens} = grammar.tokenizeLine '[role1 role2]*strong*'
      expect(tokens).toHaveLength 4
      expect(tokens[0]).toEqualJson value: '[role1 role2]', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.meta.attribute-list.asciidoc']
      expect(tokens[1]).toEqualJson value: '*', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[2]).toEqualJson value: 'strong', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc']
      expect(tokens[3]).toEqualJson value: '*', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc', 'punctuation.definition.asciidoc']

  describe 'Should tokenizes unconstrained s**t**rong text', ->

    it 'when unconstrained **strong** text', ->
      {tokens} = grammar.tokenizeLine 'this is**strong**text'
      expect(tokens[0]).toEqualJson value: 'this is', scopes: ['source.asciidoc']
      expect(tokens[1]).toEqualJson value: '**', scopes: ['source.asciidoc', 'markup.strong.unconstrained.asciidoc', 'markup.bold.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[2]).toEqualJson value: 'strong', scopes: ['source.asciidoc', 'markup.strong.unconstrained.asciidoc', 'markup.bold.asciidoc']
      expect(tokens[3]).toEqualJson value: '**', scopes: ['source.asciidoc', 'markup.strong.unconstrained.asciidoc', 'markup.bold.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[4]).toEqualJson value: 'text', scopes: ['source.asciidoc']

    it 'when unconstrained **strong** text with asterisks', ->
      {tokens} = grammar.tokenizeLine 'this is**strong*text**'
      expect(tokens[0]).toEqualJson value: 'this is', scopes: ['source.asciidoc']
      expect(tokens[1]).toEqualJson value: '**', scopes: ['source.asciidoc', 'markup.strong.unconstrained.asciidoc', 'markup.bold.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[2]).toEqualJson value: 'strong*text', scopes: ['source.asciidoc', 'markup.strong.unconstrained.asciidoc', 'markup.bold.asciidoc']
      expect(tokens[3]).toEqualJson value: '**', scopes: ['source.asciidoc', 'markup.strong.unconstrained.asciidoc', 'markup.bold.asciidoc', 'punctuation.definition.asciidoc']

    it 'when unconstrained **strong** is double escaped', ->
      {tokens} = grammar.tokenizeLine '\\\\**strong text**'
      expect(tokens).toHaveLength 1
      expect(tokens[0]).toEqualJson value: '\\\\**strong text**', scopes: ['source.asciidoc']

    it 'when having a [role] set on unconstrained **strong** text', ->
      {tokens} = grammar.tokenizeLine '[role]**strong**'
      expect(tokens).toHaveLength 4
      expect(tokens[0]).toEqualJson value: '[role]', scopes: ['source.asciidoc', 'markup.strong.unconstrained.asciidoc', 'markup.meta.attribute-list.asciidoc']
      expect(tokens[1]).toEqualJson value: '**', scopes: ['source.asciidoc', 'markup.strong.unconstrained.asciidoc', 'markup.bold.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[2]).toEqualJson value: 'strong', scopes: ['source.asciidoc', 'markup.strong.unconstrained.asciidoc', 'markup.bold.asciidoc']
      expect(tokens[3]).toEqualJson value: '**', scopes: ['source.asciidoc', 'markup.strong.unconstrained.asciidoc', 'markup.bold.asciidoc', 'punctuation.definition.asciidoc']

    it 'when having [role1 role2] set on unconstrained **strong** text', ->
      {tokens} = grammar.tokenizeLine '[role1 role2]**strong**'
      expect(tokens).toHaveLength 4
      expect(tokens[0]).toEqualJson value: '[role1 role2]', scopes: ['source.asciidoc', 'markup.strong.unconstrained.asciidoc', 'markup.meta.attribute-list.asciidoc']
      expect(tokens[1]).toEqualJson value: '**', scopes: ['source.asciidoc', 'markup.strong.unconstrained.asciidoc', 'markup.bold.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[2]).toEqualJson value: 'strong', scopes: ['source.asciidoc', 'markup.strong.unconstrained.asciidoc', 'markup.bold.asciidoc']
      expect(tokens[3]).toEqualJson value: '**', scopes: ['source.asciidoc', 'markup.strong.unconstrained.asciidoc', 'markup.bold.asciidoc', 'punctuation.definition.asciidoc']
