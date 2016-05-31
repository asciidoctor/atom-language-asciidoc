describe 'Passthrough macro', ->
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

    it 'as attribute, started at the beginning of the line and without text after.', ->
      {tokens} = grammar.tokenizeLine 'pass:q,c[<u>underline *me*</u>]'
      expect(tokens).toHaveLength 5
      expect(tokens[0]).toEqualJson value: 'pass:', scopes: ['source.asciidoc', 'markup.macro.inline.passthrough.asciidoc', 'entity.name.function.asciidoc']
      expect(tokens[1]).toEqualJson value: 'q,c', scopes: ['source.asciidoc', 'markup.macro.inline.passthrough.asciidoc', 'markup.meta.attribute-list.asciidoc']
      expect(tokens[2]).toEqualJson value: '[', scopes: ['source.asciidoc', 'markup.macro.inline.passthrough.asciidoc']
      expect(tokens[3]).toEqualJson value: '<u>underline *me*</u>', scopes: ['source.asciidoc', 'markup.macro.inline.passthrough.asciidoc', 'string.unquoted.asciidoc']
      expect(tokens[4]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.macro.inline.passthrough.asciidoc']

    it 'as attribute, in a phrase.', ->
      {tokens} = grammar.tokenizeLine 'A pass:o,x[<u>underline *me*</u>] followed by normal content.'
      expect(tokens).toHaveLength 7
      expect(tokens[0]).toEqualJson value: 'A ', scopes: ['source.asciidoc']
      expect(tokens[1]).toEqualJson value: 'pass:', scopes: ['source.asciidoc', 'markup.macro.inline.passthrough.asciidoc', 'entity.name.function.asciidoc']
      expect(tokens[2]).toEqualJson value: 'o,x', scopes: ['source.asciidoc', 'markup.macro.inline.passthrough.asciidoc', 'markup.meta.attribute-list.asciidoc']
      expect(tokens[3]).toEqualJson value: '[', scopes: ['source.asciidoc', 'markup.macro.inline.passthrough.asciidoc']
      expect(tokens[4]).toEqualJson value: '<u>underline *me*</u>', scopes: ['source.asciidoc', 'markup.macro.inline.passthrough.asciidoc', 'string.unquoted.asciidoc']
      expect(tokens[5]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.macro.inline.passthrough.asciidoc']
      expect(tokens[6]).toEqualJson value: ' followed by normal content.', scopes: ['source.asciidoc']

    it 'as triple-plus, in a phrase.', ->
      {tokens} = grammar.tokenizeLine 'A +++<u>underline *me*</u>+++ followed by normal content.'
      expect(tokens).toHaveLength 5
      expect(tokens[0]).toEqualJson value: 'A ', scopes: ['source.asciidoc']
      expect(tokens[1]).toEqualJson value: '+++', scopes: ['source.asciidoc', 'markup.macro.inline.passthrough.asciidoc', 'support.constant.asciidoc']
      expect(tokens[2]).toEqualJson value: '<u>underline *me*</u>', scopes: ['source.asciidoc', 'markup.macro.inline.passthrough.asciidoc', 'string.unquoted.asciidoc']
      expect(tokens[3]).toEqualJson value: '+++', scopes: ['source.asciidoc', 'markup.macro.inline.passthrough.asciidoc', 'support.constant.asciidoc']
      expect(tokens[4]).toEqualJson value: ' followed by normal content.', scopes: ['source.asciidoc']

    it 'as double-dollar, in a phrase.', ->
      {tokens} = grammar.tokenizeLine 'A $$<u>underline *me*</u>$$ followed by normal content.'
      expect(tokens).toHaveLength 5
      expect(tokens[0]).toEqualJson value: 'A ', scopes: ['source.asciidoc']
      expect(tokens[1]).toEqualJson value: '$$', scopes: ['source.asciidoc', 'markup.macro.inline.passthrough.asciidoc', 'support.constant.asciidoc']
      expect(tokens[2]).toEqualJson value: '<u>underline *me*</u>', scopes: ['source.asciidoc', 'markup.macro.inline.passthrough.asciidoc', 'string.unquoted.asciidoc']
      expect(tokens[3]).toEqualJson value: '$$', scopes: ['source.asciidoc', 'markup.macro.inline.passthrough.asciidoc', 'support.constant.asciidoc']
      expect(tokens[4]).toEqualJson value: ' followed by normal content.', scopes: ['source.asciidoc']
