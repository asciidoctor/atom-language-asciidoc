describe '*strong* text', ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage('language-asciidoc')

    runs ->
      grammar = atom.grammars.grammarForScopeName('source.asciidoc')

  # convenience function during development
  debug = (tokens) ->
    console.log(JSON.stringify tokens, null, ' ')

  it 'parses the grammar', ->
    expect(grammar).toBeDefined()
    expect(grammar.scopeName).toBe 'source.asciidoc'

  describe 'Should tokenizes constrained *strong* text', ->

    it 'when constrained *strong* text', ->
      {tokens} = grammar.tokenizeLine 'this is *strong* text'
      expect(tokens).toHaveLength 5
      expect(tokens[0]).toEqual value: 'this is ', scopes: ['source.asciidoc']
      expect(tokens[1]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'punctuation.definition.bold.asciidoc']
      expect(tokens[2]).toEqual value: 'strong', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.strong.asciidoc']
      expect(tokens[3]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'punctuation.definition.bold.asciidoc']
      expect(tokens[4]).toEqual value: ' text', scopes: ['source.asciidoc']

    it 'when constrained *strong* at the beginning of the line', ->
      {tokens} = grammar.tokenizeLine '*strong text* from the start.'
      expect(tokens).toHaveLength 4
      expect(tokens[0]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'punctuation.definition.bold.asciidoc']
      expect(tokens[1]).toEqual value: 'strong text', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.strong.asciidoc']
      expect(tokens[2]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'punctuation.definition.bold.asciidoc']
      expect(tokens[3]).toEqual value: ' from the start.', scopes: ['source.asciidoc']

    it 'when constrained *strong* is escaped', ->
      {tokens} = grammar.tokenizeLine '\\*strong text*'
      expect(tokens).toHaveLength 1
      expect(tokens[0]).toEqual value: '\\*strong text*', scopes: ['source.asciidoc']

    it 'when constrained *strong* in a * bulleted list', ->
      {tokens} = grammar.tokenizeLine '* *strong text* followed by normal text'
      expect(tokens).toHaveLength 6
      expect(tokens[0]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.list.asciidoc', 'markup.list.bullet.asciidoc']
      expect(tokens[1]).toEqual value: ' ', scopes: ['source.asciidoc']
      expect(tokens[2]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'punctuation.definition.bold.asciidoc']
      expect(tokens[3]).toEqual value: 'strong text', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.strong.asciidoc']
      expect(tokens[4]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'punctuation.definition.bold.asciidoc']
      expect(tokens[5]).toEqual value: ' followed by normal text', scopes: ['source.asciidoc']

    it 'when constrained *strong* text within special characters', ->
      {tokens} = grammar.tokenizeLine 'a*non-strong*a, !*strong*?, \'*strong*:, .*strong*; ,*strong*'
      expect(tokens).toHaveLength 16
      expect(tokens[0]).toEqual value: 'a*non-strong*a, !', scopes: ['source.asciidoc']
      expect(tokens[1]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'punctuation.definition.bold.asciidoc']
      expect(tokens[2]).toEqual value: 'strong', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.strong.asciidoc']
      expect(tokens[3]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'punctuation.definition.bold.asciidoc']
      expect(tokens[4]).toEqual value: '?, \'', scopes: ['source.asciidoc']
      expect(tokens[5]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'punctuation.definition.bold.asciidoc']
      expect(tokens[6]).toEqual value: 'strong', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.strong.asciidoc']
      expect(tokens[7]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'punctuation.definition.bold.asciidoc']
      expect(tokens[8]).toEqual value: ':, .', scopes: ['source.asciidoc']
      expect(tokens[9]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'punctuation.definition.bold.asciidoc']
      expect(tokens[10]).toEqual value: 'strong', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.strong.asciidoc']
      expect(tokens[11]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'punctuation.definition.bold.asciidoc']
      expect(tokens[12]).toEqual value: '; ,', scopes: ['source.asciidoc']
      expect(tokens[13]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'punctuation.definition.bold.asciidoc']
      expect(tokens[14]).toEqual value: 'strong', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.strong.asciidoc']
      expect(tokens[15]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'punctuation.definition.bold.asciidoc']

    it 'when text is "this is *strong* text"', ->
      {tokens} = grammar.tokenizeLine 'this is *strong* text'
      expect(tokens).toHaveLength 5
      expect(tokens[0]).toEqual value: 'this is ', scopes: ['source.asciidoc']
      expect(tokens[1]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'punctuation.definition.bold.asciidoc']
      expect(tokens[2]).toEqual value: 'strong', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.strong.asciidoc']
      expect(tokens[3]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'punctuation.definition.bold.asciidoc']
      expect(tokens[4]).toEqual value: ' text', scopes: ['source.asciidoc']

    it 'when text is "* text*"', ->
      {tokens} = grammar.tokenizeLine '* text*'
      expect(tokens).toHaveLength 2
      expect(tokens[0]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.list.asciidoc', 'markup.list.bullet.asciidoc']
      expect(tokens[1]).toEqual value: ' text*', scopes: ['source.asciidoc']

    it 'when text is "*strong text*"', ->
      {tokens} = grammar.tokenizeLine '*strong text*'
      expect(tokens).toHaveLength 3
      expect(tokens[0]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'punctuation.definition.bold.asciidoc']
      expect(tokens[1]).toEqual value: 'strong text', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.strong.asciidoc']
      expect(tokens[2]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'punctuation.definition.bold.asciidoc']

    it 'when text is "*strong*text*"', ->
      {tokens} = grammar.tokenizeLine '*strong*text*'
      expect(tokens).toHaveLength 3
      expect(tokens[0]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'punctuation.definition.bold.asciidoc']
      expect(tokens[1]).toEqual value: 'strong*text', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.strong.asciidoc']
      expect(tokens[2]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'punctuation.definition.bold.asciidoc']

    it 'when text is "*strong* text *strong* text"', ->
      {tokens} = grammar.tokenizeLine '*strong* text *strong* text'
      expect(tokens).toHaveLength 8
      expect(tokens[0]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'punctuation.definition.bold.asciidoc']
      expect(tokens[1]).toEqual value: 'strong', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.strong.asciidoc']
      expect(tokens[2]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'punctuation.definition.bold.asciidoc']
      expect(tokens[3]).toEqual value: ' text ', scopes: ['source.asciidoc']
      expect(tokens[4]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'punctuation.definition.bold.asciidoc']
      expect(tokens[5]).toEqual value: 'strong', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.strong.asciidoc']
      expect(tokens[6]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'punctuation.definition.bold.asciidoc']
      expect(tokens[7]).toEqual value: ' text', scopes: ['source.asciidoc']

    it 'when text is "* *strong* text" (list context)', ->
      {tokens} = grammar.tokenizeLine '* *strong* text'
      expect(tokens).toHaveLength 6
      expect(tokens[0]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.list.asciidoc', 'markup.list.bullet.asciidoc']
      expect(tokens[1]).toEqual value: ' ', scopes: ['source.asciidoc']
      expect(tokens[2]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'punctuation.definition.bold.asciidoc']
      expect(tokens[3]).toEqual value: 'strong', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.strong.asciidoc']
      expect(tokens[4]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'punctuation.definition.bold.asciidoc']
      expect(tokens[5]).toEqual value: ' text', scopes: ['source.asciidoc']

    it 'when text is "* *strong*" (list context)', ->
      {tokens} = grammar.tokenizeLine '* *strong*'
      expect(tokens).toHaveLength 5
      expect(tokens[0]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.list.asciidoc', 'markup.list.bullet.asciidoc']
      expect(tokens[1]).toEqual value: ' ', scopes: ['source.asciidoc']
      expect(tokens[2]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'punctuation.definition.bold.asciidoc']
      expect(tokens[3]).toEqual value: 'strong', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.strong.asciidoc']
      expect(tokens[4]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'punctuation.definition.bold.asciidoc']

    it 'when having a [role] set on constrained *strong* text', ->
      {tokens} = grammar.tokenizeLine '[role]*strong*'
      expect(tokens).toHaveLength 4
      expect(tokens[0]).toEqual value: '[role]', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.meta.attribute-list.asciidoc']
      expect(tokens[1]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'punctuation.definition.bold.asciidoc']
      expect(tokens[2]).toEqual value: 'strong', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.strong.asciidoc']
      expect(tokens[3]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'punctuation.definition.bold.asciidoc']

    it 'when having [role1 role2] set on constrained *strong* text', ->
      {tokens} = grammar.tokenizeLine '[role1 role2]*strong*'
      expect(tokens).toHaveLength 4
      expect(tokens[0]).toEqual value: '[role1 role2]', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.meta.attribute-list.asciidoc']
      expect(tokens[1]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'punctuation.definition.bold.asciidoc']
      expect(tokens[2]).toEqual value: 'strong', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.strong.asciidoc']
      expect(tokens[3]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.strong.constrained.asciidoc', 'punctuation.definition.bold.asciidoc']

  describe 'Should tokenizes unconstrained s**t**rong text', ->

    it 'when unconstrained **strong** text', ->
      {tokens} = grammar.tokenizeLine 'this is**strong**text'
      expect(tokens[0]).toEqual value: 'this is', scopes: ['source.asciidoc']
      expect(tokens[1]).toEqual value: '**', scopes: ['source.asciidoc', 'markup.strong.unconstrained.asciidoc', 'punctuation.definition.bold.asciidoc']
      expect(tokens[2]).toEqual value: 'strong', scopes: ['source.asciidoc', 'markup.strong.unconstrained.asciidoc', 'markup.bold.strong.asciidoc']
      expect(tokens[3]).toEqual value: '**', scopes: ['source.asciidoc', 'markup.strong.unconstrained.asciidoc', 'punctuation.definition.bold.asciidoc']
      expect(tokens[4]).toEqual value: 'text', scopes: ['source.asciidoc']

    it 'when unconstrained **strong** text with asterisks', ->
      {tokens} = grammar.tokenizeLine 'this is**strong*text**'
      expect(tokens[0]).toEqual value: 'this is', scopes: ['source.asciidoc']
      expect(tokens[1]).toEqual value: '**', scopes: ['source.asciidoc', 'markup.strong.unconstrained.asciidoc', 'punctuation.definition.bold.asciidoc']
      expect(tokens[2]).toEqual value: 'strong*text', scopes: ['source.asciidoc', 'markup.strong.unconstrained.asciidoc', 'markup.bold.strong.asciidoc']
      expect(tokens[3]).toEqual value: '**', scopes: ['source.asciidoc', 'markup.strong.unconstrained.asciidoc', 'punctuation.definition.bold.asciidoc']

    it 'when unconstrained **strong** is double escaped', ->
      {tokens} = grammar.tokenizeLine '\\\\**strong text**'
      expect(tokens).toHaveLength 1
      expect(tokens[0]).toEqual value: '\\\\**strong text**', scopes: ['source.asciidoc']

    it 'when having a [role] set on unconstrained **strong** text', ->
      {tokens} = grammar.tokenizeLine '[role]**strong**'
      expect(tokens).toHaveLength 4
      expect(tokens[0]).toEqual value: '[role]', scopes: ['source.asciidoc', 'markup.strong.unconstrained.asciidoc', 'markup.meta.attribute-list.asciidoc']
      expect(tokens[1]).toEqual value: '**', scopes: ['source.asciidoc', 'markup.strong.unconstrained.asciidoc', 'punctuation.definition.bold.asciidoc']
      expect(tokens[2]).toEqual value: 'strong', scopes: ['source.asciidoc', 'markup.strong.unconstrained.asciidoc', 'markup.bold.strong.asciidoc']
      expect(tokens[3]).toEqual value: '**', scopes: ['source.asciidoc', 'markup.strong.unconstrained.asciidoc', 'punctuation.definition.bold.asciidoc']

    it 'when having [role1 role2] set on unconstrained **strong** text', ->
      {tokens} = grammar.tokenizeLine '[role1 role2]**strong**'
      expect(tokens).toHaveLength 4
      expect(tokens[0]).toEqual value: '[role1 role2]', scopes: ['source.asciidoc', 'markup.strong.unconstrained.asciidoc', 'markup.meta.attribute-list.asciidoc']
      expect(tokens[1]).toEqual value: '**', scopes: ['source.asciidoc', 'markup.strong.unconstrained.asciidoc', 'punctuation.definition.bold.asciidoc']
      expect(tokens[2]).toEqual value: 'strong', scopes: ['source.asciidoc', 'markup.strong.unconstrained.asciidoc', 'markup.bold.strong.asciidoc']
      expect(tokens[3]).toEqual value: '**', scopes: ['source.asciidoc', 'markup.strong.unconstrained.asciidoc', 'punctuation.definition.bold.asciidoc']
