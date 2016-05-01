describe '_italic_ text', ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage 'language-asciidoc'

    runs ->
      grammar = atom.grammars.grammarForScopeName 'source.asciidoc'

  # convenience function during development
  debug = (tokens) ->
    console.log(JSON.stringify tokens, null, ' ')

  it 'parses the grammar', ->
    expect(grammar).toBeDefined()
    expect(grammar.scopeName).toBe 'source.asciidoc'

  describe 'Should tokenizes constrained _italic_ text when', ->

    it 'is in a phrase', ->
      {tokens} = grammar.tokenizeLine 'this is _italic_ text'
      expect(tokens[0]).toEqual value: 'this is ', scopes: ['source.asciidoc']
      expect(tokens[1]).toEqual value: '_italic_', scopes: ['source.asciidoc', 'markup.italic.asciidoc']
      expect(tokens[2]).toEqual value: ' text', scopes: ['source.asciidoc']

    it 'contains text with underscores', ->
      {tokens} = grammar.tokenizeLine 'this is _italic_text_ with underscores'
      expect(tokens[0]).toEqual value: 'this is ', scopes: ['source.asciidoc']
      expect(tokens[1]).toEqual value: '_italic_text_', scopes: ['source.asciidoc', 'markup.italic.asciidoc']
      expect(tokens[2]).toEqual value: ' with underscores', scopes: ['source.asciidoc']

    it 'tokenizes multi-line constrained _italic_ text', ->
      {tokens} = grammar.tokenizeLine '''
                                      this is _multi-
                                      line italic_ text
                                      '''
      expect(tokens[0]).toEqual value: 'this is ', scopes: ['source.asciidoc']
      expect(tokens[1]).toEqual value: '''
                                      _multi-
                                      line italic_
                                      ''', scopes: ['source.asciidoc', 'markup.italic.asciidoc']
      expect(tokens[2]).toEqual value: ' text', scopes: ['source.asciidoc']

    it 'tokenizes _italic_ text at the beginning of the line', ->
      {tokens} = grammar.tokenizeLine '_italic text_ from the start.'
      expect(tokens[0]).toEqual value: '_italic text_', scopes: ['source.asciidoc', 'markup.italic.asciidoc']
      expect(tokens[1]).toEqual value: ' from the start.', scopes: ['source.asciidoc']

    it 'tokenizes _italic_ text in a * bulleted list', ->
      {tokens} = grammar.tokenizeLine '* _italic text_ followed by normal text'
      expect(tokens[0]).toEqual value: '*', scopes: ['source.asciidoc', 'markup.list.asciidoc', 'markup.list.bullet.asciidoc']
      expect(tokens[1]).toEqual value: ' ', scopes: ['source.asciidoc']
      expect(tokens[2]).toEqual value: '_italic text_', scopes: ['source.asciidoc', 'markup.italic.asciidoc']
      expect(tokens[3]).toEqual value: ' followed by normal text', scopes: ['source.asciidoc']

    it 'tokenizes constrained _italic_ text within special characters', ->
      {tokens} = grammar.tokenizeLine 'a_non-italic_a, !_italic_?, \'_italic_:, ._italic_; ,_italic_'
      expect(tokens[0]).toEqual value: 'a_non-italic_a, !', scopes: ['source.asciidoc']
      expect(tokens[1]).toEqual value: '_italic_', scopes: ['source.asciidoc', 'markup.italic.asciidoc']
      expect(tokens[2]).toEqual value: '?, \'', scopes: ['source.asciidoc']
      expect(tokens[3]).toEqual value: '_italic_', scopes: ['source.asciidoc', 'markup.italic.asciidoc']
      expect(tokens[4]).toEqual value: ':, .', scopes: ['source.asciidoc']
      expect(tokens[5]).toEqual value: '_italic_', scopes: ['source.asciidoc', 'markup.italic.asciidoc']
      expect(tokens[6]).toEqual value: '; ,', scopes: ['source.asciidoc']
      expect(tokens[7]).toEqual value: '_italic_', scopes: ['source.asciidoc', 'markup.italic.asciidoc']

    it 'tokenizes variants of unbalanced underscores around _italic_ text', ->
      {tokens} = grammar.tokenizeLine '_italic_ __italic_ ___italic_ ___italic__ ___italic___ __italic___ _italic___ _italic__'
      expect(tokens[0]).toEqual value: '_italic_', scopes: ['source.asciidoc', 'markup.italic.asciidoc']
      expect(tokens[1]).toEqual value: ' ', scopes: ['source.asciidoc']
      expect(tokens[2]).toEqual value: '__italic_', scopes: ['source.asciidoc', 'markup.italic.asciidoc']
      expect(tokens[3]).toEqual value: ' ', scopes: ['source.asciidoc']
      expect(tokens[4]).toEqual value: '___italic_', scopes: ['source.asciidoc', 'markup.italic.asciidoc']
      expect(tokens[5]).toEqual value: ' ', scopes: ['source.asciidoc']
      expect(tokens[6]).toEqual value: '___italic__', scopes: ['source.asciidoc', 'markup.italic.asciidoc']
      expect(tokens[7]).toEqual value: ' ', scopes: ['source.asciidoc']
      expect(tokens[8]).toEqual value: '___italic___', scopes: ['source.asciidoc', 'markup.italic.asciidoc']
      expect(tokens[9]).toEqual value: ' ', scopes: ['source.asciidoc']
      expect(tokens[10]).toEqual value: '__italic___', scopes: ['source.asciidoc', 'markup.italic.asciidoc']
      expect(tokens[11]).toEqual value: ' ', scopes: ['source.asciidoc']
      expect(tokens[12]).toEqual value: '_italic___', scopes: ['source.asciidoc', 'markup.italic.asciidoc']
      expect(tokens[13]).toEqual value: ' ', scopes: ['source.asciidoc']
      expect(tokens[14]).toEqual value: '_italic__', scopes: ['source.asciidoc', 'markup.italic.asciidoc']

  describe 'Should tokenizes unconstrained __italic__ text when', ->

    it 'tokenizes __italic__ text', ->
      {tokens} = grammar.tokenizeLine 'this is__italic__text'
      expect(tokens[0]).toEqual value: 'this is', scopes: ['source.asciidoc']
      expect(tokens[1]).toEqual value: '__italic__', scopes: ['source.asciidoc', 'markup.italic.asciidoc']
      expect(tokens[2]).toEqual value: 'text', scopes: ['source.asciidoc']

    it 'tokenizes multi-line _italic_ text', ->
      {tokens} = grammar.tokenizeLine '''
                                      this is__multi-
                                      line italic__text
                                      '''
      expect(tokens[0]).toEqual value: 'this is', scopes: ['source.asciidoc']
      expect(tokens[1]).toEqual value: '''
                                      __multi-
                                      line italic__
                                      ''', scopes: ['source.asciidoc', 'markup.italic.asciidoc']
      expect(tokens[2]).toEqual value: 'text', scopes: ['source.asciidoc']
