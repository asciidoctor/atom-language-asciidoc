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

  describe 'Should tokenizes constrained *bold* text', ->

    it 'when constrained *bold* text', ->
      {tokens} = grammar.tokenizeLine 'this is *bold* text'
      expect(tokens).toHaveLength 5
      expect(tokens[0]).toEqual value: 'this is ', scopes: ['source.asciidoc']
      expect(tokens[1]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.bold.constrained.asciidoc', 'support.constant.asciidoc']
      expect(tokens[2]).toEqual value: 'bold', scopes: ['source.asciidoc', 'markup.bold.constrained.asciidoc']
      expect(tokens[3]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.bold.constrained.asciidoc', 'support.constant.asciidoc']
      expect(tokens[4]).toEqual value: ' text', scopes: ['source.asciidoc']

    it 'when constrained *bold* at the beginning of the line', ->
      {tokens} = grammar.tokenizeLine '*bold text* from the start.'
      expect(tokens).toHaveLength 4
      expect(tokens[0]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.bold.constrained.asciidoc', 'support.constant.asciidoc']
      expect(tokens[1]).toEqual value: 'bold text', scopes: ['source.asciidoc', 'markup.bold.constrained.asciidoc']
      expect(tokens[2]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.bold.constrained.asciidoc', 'support.constant.asciidoc']
      expect(tokens[3]).toEqual value: ' from the start.', scopes: ['source.asciidoc']

    it 'when constrained *bold* in a * bulleted list', ->
      {tokens} = grammar.tokenizeLine '* *bold text* followed by normal text'
      expect(tokens).toHaveLength 6
      expect(tokens[0]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.list.asciidoc', 'markup.list.bullet.asciidoc']
      expect(tokens[1]).toEqual value: ' ', scopes: ['source.asciidoc']
      expect(tokens[2]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.bold.constrained.asciidoc', 'support.constant.asciidoc']
      expect(tokens[3]).toEqual value: 'bold text', scopes: ['source.asciidoc', 'markup.bold.constrained.asciidoc']
      expect(tokens[4]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.bold.constrained.asciidoc', 'support.constant.asciidoc']
      expect(tokens[5]).toEqual value: ' followed by normal text', scopes: ['source.asciidoc']

    it 'when constrained *bold* text within special characters', ->
      {tokens} = grammar.tokenizeLine 'a*non-bold*a, !*bold*?, \'*bold*:, .*bold*; ,*bold*'
      expect(tokens).toHaveLength 16
      expect(tokens[0]).toEqual value: 'a*non-bold*a, !', scopes: ['source.asciidoc']
      expect(tokens[1]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.bold.constrained.asciidoc', 'support.constant.asciidoc']
      expect(tokens[2]).toEqual value: 'bold', scopes: ['source.asciidoc', 'markup.bold.constrained.asciidoc']
      expect(tokens[3]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.bold.constrained.asciidoc', 'support.constant.asciidoc']
      expect(tokens[4]).toEqual value: '?, \'', scopes: ['source.asciidoc']
      expect(tokens[5]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.bold.constrained.asciidoc', 'support.constant.asciidoc']
      expect(tokens[6]).toEqual value: 'bold', scopes: ['source.asciidoc', 'markup.bold.constrained.asciidoc']
      expect(tokens[7]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.bold.constrained.asciidoc', 'support.constant.asciidoc']
      expect(tokens[8]).toEqual value: ':, .', scopes: ['source.asciidoc']
      expect(tokens[9]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.bold.constrained.asciidoc', 'support.constant.asciidoc']
      expect(tokens[10]).toEqual value: 'bold', scopes: ['source.asciidoc', 'markup.bold.constrained.asciidoc']
      expect(tokens[11]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.bold.constrained.asciidoc', 'support.constant.asciidoc']
      expect(tokens[12]).toEqual value: '; ,', scopes: ['source.asciidoc']
      expect(tokens[13]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.bold.constrained.asciidoc', 'support.constant.asciidoc']
      expect(tokens[14]).toEqual value: 'bold', scopes: ['source.asciidoc', 'markup.bold.constrained.asciidoc']
      expect(tokens[15]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.bold.constrained.asciidoc', 'support.constant.asciidoc']

    it 'when text is "this is *bold* text"', ->
      {tokens} = grammar.tokenizeLine 'this is *bold* text'
      expect(tokens).toHaveLength 5
      expect(tokens[0]).toEqual value: 'this is ', scopes: ['source.asciidoc']
      expect(tokens[1]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.bold.constrained.asciidoc', 'support.constant.asciidoc']
      expect(tokens[2]).toEqual value: 'bold', scopes: ['source.asciidoc', 'markup.bold.constrained.asciidoc']
      expect(tokens[3]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.bold.constrained.asciidoc', 'support.constant.asciidoc']
      expect(tokens[4]).toEqual value: ' text', scopes: ['source.asciidoc']

    it 'when text is "* text*"', ->
      {tokens} = grammar.tokenizeLine '* text*'
      expect(tokens).toHaveLength 2
      expect(tokens[0]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.list.asciidoc', 'markup.list.bullet.asciidoc']
      expect(tokens[1]).toEqual value: ' text*', scopes: ['source.asciidoc']

    it 'when text is "*bold text*"', ->
      {tokens} = grammar.tokenizeLine '*bold text*'
      expect(tokens).toHaveLength 3
      expect(tokens[0]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.bold.constrained.asciidoc', 'support.constant.asciidoc']
      expect(tokens[1]).toEqual value: 'bold text', scopes: ['source.asciidoc', 'markup.bold.constrained.asciidoc']
      expect(tokens[2]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.bold.constrained.asciidoc', 'support.constant.asciidoc']

    it 'when text is "*bold*text*"', ->
      {tokens} = grammar.tokenizeLine '*bold*text*'
      expect(tokens).toHaveLength 3
      expect(tokens[0]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.bold.constrained.asciidoc', 'support.constant.asciidoc']
      expect(tokens[1]).toEqual value: 'bold*text', scopes: ['source.asciidoc', 'markup.bold.constrained.asciidoc']
      expect(tokens[2]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.bold.constrained.asciidoc', 'support.constant.asciidoc']

    it 'when text is "*bold* text *bold* text"', ->
      {tokens} = grammar.tokenizeLine '*bold* text *bold* text'
      expect(tokens).toHaveLength 8
      expect(tokens[0]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.bold.constrained.asciidoc', 'support.constant.asciidoc']
      expect(tokens[1]).toEqual value: 'bold', scopes: ['source.asciidoc', 'markup.bold.constrained.asciidoc']
      expect(tokens[2]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.bold.constrained.asciidoc', 'support.constant.asciidoc']
      expect(tokens[3]).toEqual value: ' text ', scopes: ['source.asciidoc']
      expect(tokens[4]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.bold.constrained.asciidoc', 'support.constant.asciidoc']
      expect(tokens[5]).toEqual value: 'bold', scopes: ['source.asciidoc', 'markup.bold.constrained.asciidoc']
      expect(tokens[6]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.bold.constrained.asciidoc', 'support.constant.asciidoc']
      expect(tokens[7]).toEqual value: ' text', scopes: ['source.asciidoc']

    it 'when text is "* *bold* text" (list context)', ->
      {tokens} = grammar.tokenizeLine '* *bold* text'
      expect(tokens).toHaveLength 6
      expect(tokens[0]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.list.asciidoc', 'markup.list.bullet.asciidoc']
      expect(tokens[1]).toEqual value: ' ', scopes: ['source.asciidoc']
      expect(tokens[2]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.bold.constrained.asciidoc', 'support.constant.asciidoc']
      expect(tokens[3]).toEqual value: 'bold', scopes: ['source.asciidoc', 'markup.bold.constrained.asciidoc']
      expect(tokens[4]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.bold.constrained.asciidoc', 'support.constant.asciidoc']
      expect(tokens[5]).toEqual value: ' text', scopes: ['source.asciidoc']

    it 'when text is "* *bold*" (list context)', ->
      {tokens} = grammar.tokenizeLine '* *bold*'
      expect(tokens).toHaveLength 5
      expect(tokens[0]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.list.asciidoc', 'markup.list.bullet.asciidoc']
      expect(tokens[1]).toEqual value: ' ', scopes: ['source.asciidoc']
      expect(tokens[2]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.bold.constrained.asciidoc', 'support.constant.asciidoc']
      expect(tokens[3]).toEqual value: 'bold', scopes: ['source.asciidoc', 'markup.bold.constrained.asciidoc']
      expect(tokens[4]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.bold.constrained.asciidoc', 'support.constant.asciidoc']

    it 'when having a [role] set on constrained *bold* text', ->
      {tokens} = grammar.tokenizeLine '[role]*bold*'
      expect(tokens).toHaveLength 4
      expect(tokens[0]).toEqual value: '[role]', scopes: ['source.asciidoc', 'markup.bold.constrained.asciidoc']
      expect(tokens[1]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.bold.constrained.asciidoc', 'support.constant.asciidoc']
      expect(tokens[2]).toEqual value: 'bold', scopes: ['source.asciidoc', 'markup.bold.constrained.asciidoc']
      expect(tokens[3]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.bold.constrained.asciidoc', 'support.constant.asciidoc']

    it 'when having [role1 role2] set on constrained *bold* text', ->
      {tokens} = grammar.tokenizeLine '[role1 role2]*bold*'
      expect(tokens).toHaveLength 4
      expect(tokens[0]).toEqual value: '[role1 role2]', scopes: ['source.asciidoc', 'markup.bold.constrained.asciidoc']
      expect(tokens[1]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.bold.constrained.asciidoc', 'support.constant.asciidoc']
      expect(tokens[2]).toEqual value: 'bold', scopes: ['source.asciidoc', 'markup.bold.constrained.asciidoc']
      expect(tokens[3]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.bold.constrained.asciidoc', 'support.constant.asciidoc']

  describe 'Should tokenizes unconstrained b**o**ld text', ->

    it 'when unconstrained **bold** text', ->
      {tokens} = grammar.tokenizeLine 'this is**bold**text'
      expect(tokens[0]).toEqual value: 'this is', scopes: ['source.asciidoc']
      expect(tokens[1]).toEqual value: '**', scopes: ['source.asciidoc', 'markup.bold.unconstrained.asciidoc', 'support.constant.asciidoc']
      expect(tokens[2]).toEqual value: 'bold', scopes: ['source.asciidoc', 'markup.bold.unconstrained.asciidoc']
      expect(tokens[3]).toEqual value: '**', scopes: ['source.asciidoc', 'markup.bold.unconstrained.asciidoc', 'support.constant.asciidoc']
      expect(tokens[4]).toEqual value: 'text', scopes: ['source.asciidoc']

    it 'when unconstrained **bold** text with asterisks', ->
      {tokens} = grammar.tokenizeLine 'this is**bold*text**'
      expect(tokens[0]).toEqual value: 'this is', scopes: ['source.asciidoc']
      expect(tokens[1]).toEqual value: '**', scopes: ['source.asciidoc', 'markup.bold.unconstrained.asciidoc', 'support.constant.asciidoc']
      expect(tokens[2]).toEqual value: 'bold*text', scopes: ['source.asciidoc', 'markup.bold.unconstrained.asciidoc']
      expect(tokens[3]).toEqual value: '**', scopes: ['source.asciidoc', 'markup.bold.unconstrained.asciidoc', 'support.constant.asciidoc']

    it 'when having a [role] set on unconstrained *bold* text', ->
      {tokens} = grammar.tokenizeLine '[role]**bold**'
      expect(tokens).toHaveLength 4
      expect(tokens[0]).toEqual value: '[role]', scopes: ['source.asciidoc', 'markup.bold.unconstrained.asciidoc']
      expect(tokens[1]).toEqual value: '**', scopes: ['source.asciidoc', 'markup.bold.unconstrained.asciidoc', 'support.constant.asciidoc']
      expect(tokens[2]).toEqual value: 'bold', scopes: ['source.asciidoc', 'markup.bold.unconstrained.asciidoc']
      expect(tokens[3]).toEqual value: '**', scopes: ['source.asciidoc', 'markup.bold.unconstrained.asciidoc', 'support.constant.asciidoc']

    it 'when having [role1 role2] set on unconstrained **bold** text', ->
      {tokens} = grammar.tokenizeLine '[role1 role2]**bold**'
      expect(tokens).toHaveLength 4
      expect(tokens[0]).toEqual value: '[role1 role2]', scopes: ['source.asciidoc', 'markup.bold.unconstrained.asciidoc']
      expect(tokens[1]).toEqual value: '**', scopes: ['source.asciidoc', 'markup.bold.unconstrained.asciidoc', 'support.constant.asciidoc']
      expect(tokens[2]).toEqual value: 'bold', scopes: ['source.asciidoc', 'markup.bold.unconstrained.asciidoc']
      expect(tokens[3]).toEqual value: '**', scopes: ['source.asciidoc', 'markup.bold.unconstrained.asciidoc', 'support.constant.asciidoc']
