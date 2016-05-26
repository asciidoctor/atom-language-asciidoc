describe 'Source literal', ->
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

    it 'is followed by others grammar parts', ->
      tokens = grammar.tokenizeLines '''
                                      [source,shell]
                                      ....
                                      ls -l
                                      cd ..
                                      ....
                                      <1> *Grammars* _definition_
                                      <2> *CoffeeLint* _rules_
                                      '''
      expect(tokens).toHaveLength 7 # Number of lines
      expect(tokens[0]).toHaveLength 5
      expect(tokens[0][0]).toEqualJson value: '[', scopes: ['source.asciidoc', 'markup.code.shell.asciidoc', 'markup.heading.asciidoc']
      expect(tokens[0][1]).toEqualJson value: 'source', scopes: ['source.asciidoc', 'markup.code.shell.asciidoc', 'markup.heading.asciidoc', 'markup.meta.attribute-list.asciidoc', 'entity.name.function.asciidoc']
      expect(tokens[0][2]).toEqualJson value: ',', scopes: ['source.asciidoc', 'markup.code.shell.asciidoc', 'markup.heading.asciidoc', 'punctuation.separator.asciidoc']
      expect(tokens[0][3]).toEqualJson value: 'shell', scopes: ['source.asciidoc', 'markup.code.shell.asciidoc', 'markup.heading.asciidoc', 'markup.meta.attribute-list.asciidoc']
      expect(tokens[0][4]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.code.shell.asciidoc', 'markup.heading.asciidoc']
      expect(tokens[1]).toHaveLength 1
      expect(tokens[1][0]).toEqualJson value: '....', scopes: ['source.asciidoc', 'markup.code.shell.asciidoc']
      expect(tokens[2]).toHaveLength 1
      expect(tokens[2][0]).toEqualJson value: 'ls -l', scopes: ['source.asciidoc', 'markup.code.shell.asciidoc', 'source.embedded.shell']
      expect(tokens[3]).toHaveLength 1
      expect(tokens[3][0]).toEqualJson value: 'cd ..', scopes: ['source.asciidoc', 'markup.code.shell.asciidoc', 'source.embedded.shell']
      expect(tokens[4]).toHaveLength 2
      expect(tokens[4][0]).toEqualJson value: '....', scopes: ['source.asciidoc', 'markup.code.shell.asciidoc']
      expect(tokens[4][1]).toEqualJson value: '', scopes: ['source.asciidoc', 'markup.code.shell.asciidoc']
      expect(tokens[5]).toHaveLength 11
      expect(tokens[5][0]).toEqualJson value: '<', scopes: ['source.asciidoc', 'callout.asciidoc', 'constant.other.symbol.asciidoc']
      expect(tokens[5][1]).toEqualJson value: '1', scopes: ['source.asciidoc', 'callout.asciidoc', 'constant.numeric.asciidoc']
      expect(tokens[5][2]).toEqualJson value: '>', scopes: ['source.asciidoc', 'callout.asciidoc', 'constant.other.symbol.asciidoc']
      expect(tokens[5][3]).toEqualJson value: ' ', scopes: ['source.asciidoc', 'callout.asciidoc']
      expect(tokens[5][4]).toEqualJson value: '*', scopes: ['source.asciidoc', 'callout.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[5][5]).toEqualJson value: 'Grammars', scopes: ['source.asciidoc', 'callout.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc']
      expect(tokens[5][6]).toEqualJson value: '*', scopes: [ 'source.asciidoc', 'callout.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[5][7]).toEqualJson value: ' ', scopes: ['source.asciidoc', 'callout.asciidoc']
      expect(tokens[5][8]).toEqualJson value: '_', scopes: ['source.asciidoc', 'callout.asciidoc', 'markup.emphasis.constrained.asciidoc', 'markup.italic.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[5][9]).toEqualJson value: 'definition', scopes: ['source.asciidoc', 'callout.asciidoc', 'markup.emphasis.constrained.asciidoc', 'markup.italic.asciidoc']
      expect(tokens[5][10]).toEqualJson value: '_', scopes: ['source.asciidoc', 'callout.asciidoc', 'markup.emphasis.constrained.asciidoc', 'markup.italic.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[5]).toHaveLength 11
      expect(tokens[6][0]).toEqualJson value: '<', scopes: ['source.asciidoc', 'callout.asciidoc', 'constant.other.symbol.asciidoc']
      expect(tokens[6][1]).toEqualJson value: '2', scopes: ['source.asciidoc', 'callout.asciidoc', 'constant.numeric.asciidoc']
      expect(tokens[6][2]).toEqualJson value: '>', scopes: ['source.asciidoc', 'callout.asciidoc', 'constant.other.symbol.asciidoc']
      expect(tokens[6][3]).toEqualJson value: ' ', scopes: ['source.asciidoc', 'callout.asciidoc']
      expect(tokens[6][4]).toEqualJson value: '*', scopes: ['source.asciidoc', 'callout.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[6][5]).toEqualJson value: 'CoffeeLint', scopes: ['source.asciidoc', 'callout.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc']
      expect(tokens[6][6]).toEqualJson value: '*', scopes: ['source.asciidoc', 'callout.asciidoc', 'markup.strong.constrained.asciidoc', 'markup.bold.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[6][7]).toEqualJson value: ' ', scopes: ['source.asciidoc', 'callout.asciidoc']
      expect(tokens[6][8]).toEqualJson value: '_', scopes: ['source.asciidoc', 'callout.asciidoc', 'markup.emphasis.constrained.asciidoc', 'markup.italic.asciidoc', 'punctuation.definition.asciidoc']
      expect(tokens[6][9]).toEqualJson value: 'rules', scopes: ['source.asciidoc', 'callout.asciidoc', 'markup.emphasis.constrained.asciidoc', 'markup.italic.asciidoc']
      expect(tokens[6][10]).toEqualJson value: '_', scopes: ['source.asciidoc', 'callout.asciidoc', 'markup.emphasis.constrained.asciidoc', 'markup.italic.asciidoc', 'punctuation.definition.asciidoc']

    it 'contains substitutions in additional attributes', ->
      tokens = grammar.tokenizeLines '''
        [source,java,subs="{markup-in-source}"]
        ....
        System.out.println("Hello *strong* text").
        ....
        '''
      expect(tokens).toHaveLength 4 # Number of lines
      expect(tokens[0]).toHaveLength 9
      expect(tokens[0][0]).toEqualJson value: '[', scopes: ['source.asciidoc', 'markup.code.java.asciidoc', 'markup.heading.asciidoc']
      expect(tokens[0][1]).toEqualJson value: 'source', scopes: ['source.asciidoc', 'markup.code.java.asciidoc', 'markup.heading.asciidoc', 'markup.meta.attribute-list.asciidoc', 'entity.name.function.asciidoc']
      expect(tokens[0][2]).toEqualJson value: ',', scopes: ['source.asciidoc', 'markup.code.java.asciidoc', 'markup.heading.asciidoc', 'punctuation.separator.asciidoc']
      expect(tokens[0][3]).toEqualJson value: 'java', scopes: ['source.asciidoc', 'markup.code.java.asciidoc', 'markup.heading.asciidoc', 'markup.meta.attribute-list.asciidoc']
      expect(tokens[0][4]).toEqualJson value: ',', scopes: ['source.asciidoc', 'markup.code.java.asciidoc', 'markup.heading.asciidoc', 'punctuation.separator.asciidoc']
      expect(tokens[0][5]).toEqualJson value: 'subs="', scopes: ['source.asciidoc', 'markup.code.java.asciidoc', 'markup.heading.asciidoc', 'markup.meta.attribute-list.asciidoc']
      expect(tokens[0][6]).toEqualJson value: '{markup-in-source}', scopes: ['source.asciidoc', 'markup.code.java.asciidoc', 'markup.heading.asciidoc', 'markup.meta.attribute-list.asciidoc', 'markup.substitution.attribute-reference.asciidoc']
      expect(tokens[0][7]).toEqualJson value: '"', scopes: ['source.asciidoc', 'markup.code.java.asciidoc', 'markup.heading.asciidoc', 'markup.meta.attribute-list.asciidoc']
      expect(tokens[0][8]).toEqualJson value: ']', scopes: ['source.asciidoc', 'markup.code.java.asciidoc', 'markup.heading.asciidoc']
      expect(tokens[1]).toHaveLength 1
      expect(tokens[1][0]).toEqualJson value: '....', scopes: ['source.asciidoc', 'markup.code.java.asciidoc']
      expect(tokens[2]).toHaveLength 1
      expect(tokens[2][0]).toEqualJson value: 'System.out.println("Hello *strong* text").', scopes: ['source.asciidoc', 'markup.code.java.asciidoc', 'source.embedded.java']
      expect(tokens[3]).toHaveLength 2
      expect(tokens[3][0]).toEqualJson value: '....', scopes: ['source.asciidoc', 'markup.code.java.asciidoc']
      expect(tokens[3][1]).toEqualJson value: '', scopes: ['source.asciidoc', 'markup.code.java.asciidoc']
