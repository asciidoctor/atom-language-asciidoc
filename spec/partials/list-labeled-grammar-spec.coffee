describe 'Labeled list', ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage 'language-asciidoc'

    runs ->
      grammar = atom.grammars.grammarForScopeName 'source.asciidoc'

  it 'parses the grammar', ->
    expect(grammar).toBeDefined()
    expect(grammar.scopeName).toBe 'source.asciidoc'

  describe 'Should tokenizes labeled list when', ->

    it 'line ending with ::', ->
      {tokens} = grammar.tokenizeLine 'foobar::'
      expect(tokens).toHaveLength 2
      expect(tokens[0]).toEqualJson value: 'foobar', scopes: ['source.asciidoc', 'markup.heading.list.asciidoc']
      expect(tokens[1]).toEqualJson value: '::', scopes: ['source.asciidoc', 'markup.heading.list.asciidoc', 'markup.list.bullet.asciidoc']

    it 'line ending with :::', ->
      {tokens} = grammar.tokenizeLine 'foobar:::'
      expect(tokens).toHaveLength 2
      expect(tokens[0]).toEqualJson value: 'foobar', scopes: ['source.asciidoc', 'markup.heading.list.asciidoc']
      expect(tokens[1]).toEqualJson value: ':::', scopes: ['source.asciidoc', 'markup.heading.list.asciidoc', 'markup.list.bullet.asciidoc']

    it 'line ending with ::::', ->
      {tokens} = grammar.tokenizeLine 'foobar::::'
      expect(tokens).toHaveLength 2
      expect(tokens[0]).toEqualJson value: 'foobar', scopes: ['source.asciidoc', 'markup.heading.list.asciidoc']
      expect(tokens[1]).toEqualJson value: '::::', scopes: ['source.asciidoc', 'markup.heading.list.asciidoc', 'markup.list.bullet.asciidoc']

    it 'line ending with ;;', ->
      {tokens} = grammar.tokenizeLine 'foobar;;'
      expect(tokens).toHaveLength 2
      expect(tokens[0]).toEqualJson value: 'foobar', scopes: ['source.asciidoc', 'markup.heading.list.asciidoc']
      expect(tokens[1]).toEqualJson value: ';;', scopes: ['source.asciidoc', 'markup.heading.list.asciidoc', 'markup.list.bullet.asciidoc']

    it 'contains :: following by text', ->
      {tokens} = grammar.tokenizeLine 'foobar:: foobar'
      expect(tokens).toHaveLength 4
      expect(tokens[0]).toEqualJson value: 'foobar', scopes: ['source.asciidoc', 'markup.heading.list.asciidoc']
      expect(tokens[1]).toEqualJson value: '::', scopes: ['source.asciidoc', 'markup.heading.list.asciidoc', 'markup.list.bullet.asciidoc']
      expect(tokens[2]).toEqualJson value: ' ', scopes: ['source.asciidoc', 'markup.heading.list.asciidoc']
      expect(tokens[3]).toEqualJson value: 'foobar', scopes: ['source.asciidoc']

    it 'contains ::: following by text', ->
      {tokens} = grammar.tokenizeLine 'foobar::: foobar'
      expect(tokens).toHaveLength 4
      expect(tokens[0]).toEqualJson value: 'foobar', scopes: ['source.asciidoc', 'markup.heading.list.asciidoc']
      expect(tokens[1]).toEqualJson value: ':::', scopes: ['source.asciidoc', 'markup.heading.list.asciidoc', 'markup.list.bullet.asciidoc']
      expect(tokens[2]).toEqualJson value: ' ', scopes: ['source.asciidoc', 'markup.heading.list.asciidoc']
      expect(tokens[3]).toEqualJson value: 'foobar', scopes: ['source.asciidoc']

    it 'contains :::: following by textcontains :: following by text', ->
      {tokens} = grammar.tokenizeLine 'foobar:::: foobar'
      expect(tokens).toHaveLength 4
      expect(tokens[0]).toEqualJson value: 'foobar', scopes: ['source.asciidoc', 'markup.heading.list.asciidoc']
      expect(tokens[1]).toEqualJson value: '::::', scopes: ['source.asciidoc', 'markup.heading.list.asciidoc', 'markup.list.bullet.asciidoc']
      expect(tokens[2]).toEqualJson value: ' ', scopes: ['source.asciidoc', 'markup.heading.list.asciidoc']
      expect(tokens[3]).toEqualJson value: 'foobar', scopes: ['source.asciidoc']

    it 'contains ;; following by text', ->
      {tokens} = grammar.tokenizeLine 'foobar;; foobar'
      expect(tokens).toHaveLength 4
      expect(tokens[0]).toEqualJson value: 'foobar', scopes: ['source.asciidoc', 'markup.heading.list.asciidoc']
      expect(tokens[1]).toEqualJson value: ';;', scopes: ['source.asciidoc', 'markup.heading.list.asciidoc', 'markup.list.bullet.asciidoc']
      expect(tokens[2]).toEqualJson value: ' ', scopes: ['source.asciidoc', 'markup.heading.list.asciidoc']
      expect(tokens[3]).toEqualJson value: 'foobar', scopes: ['source.asciidoc']

    it 'contains attribute reference and url', ->
      {tokens} = grammar.tokenizeLine '{uri-asciidoctorjs-npm}[asciidoctor.js]:: the main npm package for Asciidoctor.js'
      expect(tokens).toHaveLength 7
      tokenIndex = 0
      expect(tokens[tokenIndex++]).toEqualJson value: '{uri-asciidoctorjs-npm}', scopes: ['source.asciidoc', 'markup.heading.list.asciidoc', 'markup.other.url.asciidoc', 'markup.substitution.attribute-reference.asciidoc']
      expect(tokens[tokenIndex++]).toEqualJson value: '[', scopes: ['source.asciidoc', 'markup.heading.list.asciidoc', 'markup.other.url.asciidoc']
      expect(tokens[tokenIndex++]).toEqualJson value: 'asciidoctor.js', scopes: ['source.asciidoc', 'markup.heading.list.asciidoc', 'markup.other.url.asciidoc', 'string.unquoted.asciidoc']
      expect(tokens[tokenIndex++]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.heading.list.asciidoc', 'markup.other.url.asciidoc']
      expect(tokens[tokenIndex++]).toEqualJson value: '::', scopes: ['source.asciidoc', 'markup.heading.list.asciidoc', 'markup.list.bullet.asciidoc']
      expect(tokens[tokenIndex++]).toEqualJson value: ' ', scopes: ['source.asciidoc', 'markup.heading.list.asciidoc']
      expect(tokens[tokenIndex++]).toEqualJson value: 'the main npm package for Asciidoctor.js', scopes: ['source.asciidoc']
      expect(tokenIndex).toBe 7

  describe 'Should not tokenize when', ->

    it 'title ending with space', ->
      {tokens} = grammar.tokenizeLine 'foobar ::'
      expect(tokens).toHaveLength 1
      expect(tokens[0]).toEqualJson value: 'foobar ::', scopes: ['source.asciidoc']

    it 'contains only one :', ->
      {tokens} = grammar.tokenizeLine 'foobar:'
      expect(tokens).toHaveLength 1
      expect(tokens[0]).toEqualJson value: 'foobar:', scopes: ['source.asciidoc']

    it 'following by test without space', ->
      {tokens} = grammar.tokenizeLine 'foobar:foobar'
      expect(tokens).toHaveLength 1
      expect(tokens[0]).toEqualJson value: 'foobar:foobar', scopes: ['source.asciidoc']
